#! /bin/bash
# SPDX-License-Identifier: GPL-2.0
#
# The goal is to launch (MPTCP) kernel selftests and more.
# But also to provide a dev env for kernel developers or testers.
#
# Arguments:
#   - "manual": to have a console in the VM. Additional args are for the kconfig
#   - args we pass to kernel's "scripts/config" script.

# We should manage all errors in this script
set -e

is_ci() {
	[ "${CI}" = "true" ]
}

is_github_action() {
	[ "${GITHUB_ACTIONS}" = "true" ]
}

trace_needed() {
	[ "${INPUT_TRACE}" = "1" ]
}

set_trace_on() {
	if trace_needed; then
		set -x
	fi
}

set_trace_off() {
	if trace_needed; then
		set +x
	fi
}

with_clang() {
	[ "${INPUT_CLANG}" = "1" ]
}

set_trace_on

# The behaviour can be changed with 'input' env var
: "${INPUT_CCACHE_MAXSIZE:=5G}"
: "${INPUT_NO_BLOCK:=0}"
: "${INPUT_PACKETDRILL_NO_SYNC:=0}"
: "${INPUT_PACKETDRILL_NO_MORE_TOLERANCE:=0}"
: "${INPUT_PACKETDRILL_STABLE:=0}"
: "${INPUT_RUN_LOOP_CONTINUE:=0}"
: "${INPUT_RUN_TESTS_ONLY:=""}"
: "${INPUT_RUN_TESTS_EXCEPT:=""}"
: "${INPUT_SELFTESTS_DIR:=""}"
: "${INPUT_SELFTESTS_MPTCP_LIB_EXPECT_ALL_FEATURES:=1}"
: "${INPUT_SELFTESTS_MPTCP_LIB_OVERRIDE_FLAKY:=0}"
: "${INPUT_SELFTESTS_MPTCP_LIB_COLOR_FORCE:=1}"
: "${INPUT_CPUS:=""}"
: "${INPUT_CI_RESULTS_DIR:=""}"
: "${INPUT_CI_PRINT_EXIT_CODE:=1}"
: "${INPUT_CI_TIMEOUT_SEC:=7200}"
: "${INPUT_EXPECT_TIMEOUT:="-1"}"
: "${INPUT_BUILD_SKIP_PERF:=1}"

if [ -z "${INPUT_MODE}" ]; then
	INPUT_MODE="${1}"
	shift || true # none set
fi

# to be able to set an extra env var
if [[ "${INPUT_EXTRA_ENV}" =~ ^"INPUT_"[A-Z0-9_]+"="[a-zA-Z0-9_]+$ ]]; then
	eval "${INPUT_EXTRA_ENV}"
fi

: "${PACKETDRILL_GIT_BRANCH:=mptcp-net-next}"
: "${VIRTME_ARCH:="$(uname -m)"}"

TIMESTAMPS_SEC_START=$(date +%s)
# CI only: estimated time before (clone + boot) and after (artifacts) running this script
VIRTME_CI_ESTIMATED_EXTRA_TIME="540"

# max time to boot: it should take less than one minute with a debug kernel, *5 to be safe
VIRTME_EXPECT_BOOT_TIMEOUT="300"

KERNEL_SRC="${PWD}"

# used to pass environment variables to the VM
BASH_PROFILE="/root/.bash_profile"

VIRTME_WORKDIR="${KERNEL_SRC}/.virtme"
VIRTME_BUILD_DIR="${VIRTME_WORKDIR}/build"
with_clang && VIRTME_BUILD_DIR+="-clang"
VIRTME_SCRIPTS_DIR="${VIRTME_WORKDIR}/scripts"
VIRTME_HEADERS_DIR="${VIRTME_WORKDIR}/headers"
VIRTME_PERF_DIR="${VIRTME_BUILD_DIR}/tools/perf"
VIRTME_TOOLS_SBIN_DIR="${VIRTME_BUILD_DIR}/tools/sbin"
VIRTME_CACHE_DIR="${VIRTME_BUILD_DIR}/.cache"

VIRTME_KCONFIG="${VIRTME_BUILD_DIR}/.config"

VIRTME_SCRIPT="${VIRTME_SCRIPTS_DIR}/tests.sh"
VIRTME_SCRIPT_END="__VIRTME_END__"
VIRTME_SCRIPT_UNEXPECTED_STOP="Unexpected stop of the VM"
VIRTME_RUN_SCRIPT="${VIRTME_SCRIPTS_DIR}/virtme.sh"
VIRTME_RUN_EXPECT="${VIRTME_SCRIPTS_DIR}/virtme.expect"

SELFTESTS_DIR="${INPUT_SELFTESTS_DIR:-tools/testing/selftests/net/mptcp}"
SELFTESTS_CONFIG="${SELFTESTS_DIR}/config"
BPFTESTS_DIR="${INPUT_BPFTESTS_DIR:-tools/testing/selftests/bpf}"
BPFTESTS_CONFIG="${BPFTESTS_DIR}/config"

export CCACHE_MAXSIZE="${INPUT_CCACHE_MAXSIZE}"
export CCACHE_DIR="${VIRTME_WORKDIR}/ccache"
with_clang && CCACHE_DIR+="-clang"

export KBUILD_OUTPUT="${VIRTME_BUILD_DIR}"
export KCONFIG_CONFIG="${VIRTME_KCONFIG}"

mkdir -p \
	"${VIRTME_BUILD_DIR}" \
	"${VIRTME_SCRIPTS_DIR}" \
	"${VIRTME_HEADERS_DIR}" \
	"${VIRTME_PERF_DIR}" \
	"${VIRTME_CACHE_DIR}" \
	"${CCACHE_DIR}"
chmod 777 "${VIRTME_CACHE_DIR}" # to let users writting files there, e.g. clangd

VIRTME_CONFIGKERNEL="virtme-configkernel"
VIRTME_RUN="virtme-run"
VIRTME_RUN_OPTS_DEFAULT=(
	--arch "${VIRTME_ARCH}"
	--name "mptcpdev"  # hostname
	--memory 2048M
	--kdir "${VIRTME_BUILD_DIR}"
	--mods=auto
	--rw  # Don't use "rwdir", it will use 9p ; in a container, we can use rw
	--pwd
	--show-command
	--verbose --show-boot-console
	--kopt mitigations=off
)

# results dir
RESULTS_DIR_BASE="${VIRTME_WORKDIR}/results"
RESULTS_DIR=

# log files
OUTPUT_VIRTME=
TESTS_SUMMARY=
CONCLUSION=
KMEMLEAK=

EXIT_STATUS=0
EXIT_REASONS=()
EXIT_TITLE="KVM Validation"
EXPECT=0
VIRTME_EXEC_RUN="${KERNEL_SRC}/.virtme-exec-run"
VIRTME_EXEC_PRE="${KERNEL_SRC}/.virtme-exec-pre"
VIRTME_EXEC_POST="${KERNEL_SRC}/.virtme-exec-post"
VIRTME_PREPARE_POST="${KERNEL_SRC}/.virtme-prepare-post"

COLOR_RED="\E[1;31m"
COLOR_GREEN="\E[1;32m"
COLOR_YELLOW="\E[1;33m"
COLOR_BLUE="\E[1;34m"
COLOR_RESET="\E[0m"

# $1: color, $2: text
print_color() {
	echo -e "${START_PRINT:-}${*}${COLOR_RESET}"
}

print() {
	print_color "${COLOR_GREEN}${*}"
}

printinfo() {
	print_color "${COLOR_BLUE}${*}"
}

printerr() {
	print_color "${COLOR_RED}${*}" >&2
}

if is_github_action; then
	# $1: description
	log_section_start() {
		echo -e "\n::group::${COLOR_YELLOW}${*}${COLOR_RESET}"
	}

	log_section_end() {
		echo -e "::endgroup::\n"
	}
else
	# $1: description
	log_section_start() {
		printinfo "${@}"
	}

	log_section_end() {
		true
	}
fi

setup_env() { local mode net=()
	mode="${1}"

	log_section_start "Setup environment"

	# Avoid 'unsafe repository' error: we need to get the rev/tag later from
	# this docker image
	git config --global --replace-all safe.directory "${KERNEL_SRC}" || true

	# Set a name, just in case for automations
	git config --global user.name "MPTCP Virtme Docker"
	git config --global user.email "DO-NOT@SEND.THIS"

	if is_ci; then
		# Root dir: not to have to go down dirs to get artifacts
		RESULTS_DIR="${KERNEL_SRC}${INPUT_CI_RESULTS_DIR:+/${INPUT_CI_RESULTS_DIR}}"
		mkdir -p "${RESULTS_DIR}"

		: "${INPUT_CPUS:=$(nproc)}" # use all available resources

		EXIT_TITLE="${EXIT_TITLE}: ${mode}" # only one mode

		if [ -n "${INPUT_RUN_TESTS_ONLY}" ]; then
			EXIT_TITLE="${EXIT_TITLE} (only ${INPUT_RUN_TESTS_ONLY})"
		fi

		if [ -n "${INPUT_RUN_TESTS_EXCEPT}" ]; then
			EXIT_TITLE="${EXIT_TITLE} (except ${INPUT_RUN_TESTS_EXCEPT})"
		fi

		# The CI doesn't need to access to the outside world, so no '--net'
	else
		# avoid override
		RESULTS_DIR="${RESULTS_DIR_BASE}/$(git rev-parse --short HEAD || echo "UNKNOWN")/${mode}"
		rm -rf "${RESULTS_DIR}"
		mkdir -p "${RESULTS_DIR}"

		: "${INPUT_CPUS:=2}" # limit to 2 cores for now

		# add net support, can be useful, but delay the start of the tests (~1 sec?)
		net=("--net")
	fi

	VIRTME_RUN_OPTS=(
		"${VIRTME_RUN_OPTS_DEFAULT[@]}"
		--cpus "${INPUT_CPUS}"
		"${net[@]}"
	)

	OUTPUT_VIRTME="${RESULTS_DIR}/output.log"
	TESTS_SUMMARY="${RESULTS_DIR}/summary.txt"
	CONCLUSION="${RESULTS_DIR}/conclusion.txt"
	KMEMLEAK="${RESULTS_DIR}/kmemleak.txt"

	KVERSION=$(make -C "${KERNEL_SRC}" -s kernelversion) ## 5.17.0 or 5.17.0-rc8
	KVER_MAJ=${KVERSION%%.*} ## 5
	KVER_MIN=${KVERSION#*.} ## 17.0*
	KVER_MIC=${KVER_MIN#*.} ## 0
	KVER_MIN=${KVER_MIN%%.*} ## 17

	# without rc, it means we probably already merged with net-next
	if [[ ! "${KVERSION}" =~ rc ]] && [ "${KVER_MIC}" = 0 ]; then
		KVER_MIN=$((KVER_MIN + 1))

		# max .19 because Linus has 20 fingers
		if [ ${KVER_MIN} -gt 19 ]; then
			KVER_MAJ=$((KVER_MAJ + 1))
			KVER_MIN=0
		fi
	fi

	if [ "${KVER_MAJ}" -lt 5 ] ||
	   { [ "${KVER_MAJ}" -eq 5 ] && [ "${KVER_MIN}" -le 10 ]; }; then
		# virtiofs doesn't seem to be supported on old kernels
		VIRTME_RUN_OPTS+=(--force-9p)
	fi

	log_section_end
}

_get_last_iproute_version() {
	curl https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/refs/tags 2>/dev/null | \
		grep "/tag/?h=v[0-9]" | \
		cut -d\' -f2 | cut -d= -f2 | \
		sort -Vu | \
		tail -n1
}

check_last_iproute() { local last curr
	# only check on CI
	if ! is_ci; then
		return 0
	fi

	# skip the check for stable, fine not to have the latest version
	if [ "${INPUT_PACKETDRILL_STABLE}" = "1" ]; then
		return 0
	fi

	log_section_start "Check IPRoute2 version"

	last="$(_get_last_iproute_version)"
	curr="v$(ip -V | sed 's/.*iproute2-\([0-9.]\+\).*/\1/')"
	if [ "${curr}" = "${last}" ]; then
		printinfo "IPRoute2: using the last version: ${last}"
	else
		printerr "WARN: IPRoute2: not the last version: ${curr} < ${last}"
	fi

	log_section_end
}

_check_source_exec_one() {
	local src="${1}"
	local reason="${2}"

	if [ -f "${src}" ]; then
		printinfo "This script file exists and will be used ${reason}: $(basename "${src}")"
		cat -n "${src}"

		if is_ci || [ "${INPUT_NO_BLOCK}" = "1" ]; then
			printinfo "Check source exec: not blocking"
		else
			print "Press Enter to continue (use 'INPUT_NO_BLOCK=1' to avoid this)"
			read -r
		fi
	fi
}

check_source_exec_all() {
	log_section_start "Check extented exec files"

	_check_source_exec_one "${VIRTME_EXEC_PRE}" "before the tests suite"
	_check_source_exec_one "${VIRTME_EXEC_RUN}" "to replace the execution of the whole tests suite"
	_check_source_exec_one "${VIRTME_EXEC_POST}" "after the tests suite"

	log_section_end
}

read -ra MAKE_ARGS <<< "${INPUT_MAKE_ARGS}"
with_clang && MAKE_ARGS+=(LLVM=1 LLVM_IAS=1 CC=clang ARCH="${VIRTME_ARCH}")
MAKE_ARGS_O=("${MAKE_ARGS[@]}" O="${VIRTME_BUILD_DIR}")

_make_j() {
	make -j"$(nproc)" -l"$(nproc)" "${@}"
}

_make() {
	_make_j "${MAKE_ARGS[@]}" "${@}"
}

_make_o() {
	_make_j "${MAKE_ARGS_O[@]}" "${@}"
}

# $1: source ; $2: target
_add_symlink() {
	local src="${1}"
	local dst="${2}"

	if [ -e "${dst}" ] && [ ! -L "${dst}" ]; then
		printerr "${dst} already exists and is not a symlink, please remove it"
		return 1
	fi

	ln -sf "${src}" "${dst}"
}

# $1: mode ; [rest: extra kconfig]
gen_kconfig() { local mode kconfig=() vck rc=0
	mode="${1}"
	shift

	log_section_start "Generate kernel config"

	vck=(--arch "${VIRTME_ARCH}" --defconfig --custom "${SELFTESTS_CONFIG}")

	if [ "${mode}" = "debug" ]; then
		kconfig+=(
			-e NET_NS_REFCNT_TRACKER # useful for 'net' tests
			-d SLUB_DEBUG_ON # perf impact is too important
			-e BOOTPARAM_SOFTLOCKUP_PANIC # instead of blocking
			-e BOOTPARAM_HUNG_TASK_PANIC # instead of blocking
		)

		vck+=(--custom kernel/configs/debug.config)
	else
		# low-overhead sampling-based memory safety error detector.
		# Only in non-debug: KASAN is more precise
		kconfig+=(-e KFENCE)
	fi

	# stop at the first oops, no need to continue in a bad state
	kconfig+=(-e PANIC_ON_OOPS)

	# Debug info for developers
	kconfig+=(-e DEBUG_INFO -e DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT -e GDB_SCRIPTS)
	if with_clang; then
		kconfig+=(-e DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT)
	else
		# decode_stacktrace.sh script reports '??:?' with GCC and DWARF5
		kconfig+=(-e DEBUG_INFO_DWARF4)
	fi

	# Compressed (old/new option)
	kconfig+=(-e DEBUG_INFO_COMPRESSED -e DEBUG_INFO_COMPRESSED_ZLIB)

	# We need more debug info but it is slow to generate
	if [ "${mode}" = "btf" ]; then
		vck+=(--custom "${BPFTESTS_CONFIG}")
		kconfig+=(-e DEBUG_INFO_BTF_MODULES -e MODULE_ALLOW_BTF_MISMATCH)
		# Fix ./include/linux/if.h:28:10: fatal error:
		#		sys/socket.h: no such file or directory
		kconfig+=(-d IA32_EMULATION)
	elif is_ci || [ "${mode}" != "debsym" ]; then
		kconfig+=(-e DEBUG_INFO_REDUCED -e DEBUG_INFO_SPLIT)
	fi

	# Debug tools for developers
	kconfig+=(
		-e DYNAMIC_DEBUG --set-val CONSOLE_LOGLEVEL_DEFAULT 8
		-e FTRACE -e FUNCTION_TRACER -e DYNAMIC_FTRACE
		-e FTRACE_SYSCALLS -e HIST_TRIGGERS
	)

	# Extra sanity checks in networking: for the moment, small checks
	kconfig+=(-e DEBUG_NET)

	# Extra options needed for MPTCP KUnit tests
	kconfig+=(-m KUNIT -e KUNIT_DEBUGFS -d KUNIT_ALL_TESTS -m MPTCP_KUNIT_TEST)

	# Options for BPF
	kconfig+=(-e BPF_JIT -e BPF_SYSCALL)

	# Extra options needed for packetdrill
	# note: we still need SHA1 for fallback tests with v0
	kconfig+=(-e TUN -e CRYPTO_USER_API_HASH -e CRYPTO_SHA1)

	# Useful to reproduce issue
	kconfig+=(-e NET_SCH_TBF)

	# Disable retpoline to accelerate tests
	kconfig+=(-d RETPOLINE)

	# Disable components we don't need
	kconfig+=(
		-d PCCARD -d MACINTOSH_DRIVERS -d SOUND -d USB_SUPPORT
		-d NEW_LEDS -d SURFACE_PLATFORMS -d DRM -d FB
	)

	# extra config
	kconfig+=("${@}")

	# KBUILD_OUTPUT is used by virtme
	"${VIRTME_CONFIGKERNEL}" "${vck[@]}" "${MAKE_ARGS_O[@]}" || rc=${?}

	./scripts/config --file "${VIRTME_KCONFIG}" "${kconfig[@]}" || rc=${?}

	_make_o olddefconfig || rc=${?}

	if is_ci; then
		# Useful to help reproducing issues later
		zstd -19 -T0 "${VIRTME_KCONFIG}" -o "${RESULTS_DIR}/config.zstd" || rc=${?}
	fi

	log_section_end

	return ${rc}
}

build_kernel() { local rc=0
	log_section_start "Build kernel"

	_make_o || rc=${?}

	# virtme will mount a tmpfs there + symlink to .virtme_mods
	mkdir -p /lib/modules

	log_section_end

	return ${rc}
}

build_compile_commands() { local rc=0
	log_section_start "Build compile_commands.json"

	_make_o compile_commands.json || rc=${?}

	log_section_end

	return ${rc}
}

install_kernel_headers() { local rc=0
	log_section_start "Install kernel headers"

	# for BPFTrace and cie
	cp -r include/ "${VIRTME_BUILD_DIR}"

	_make_o headers_install INSTALL_HDR_PATH="${VIRTME_HEADERS_DIR}" || rc=${?}

	log_section_end

	return ${rc}

}

build_perf() { local rc=0
	if [ "${INPUT_BUILD_SKIP_PERF}" = 1 ]; then
		printinfo "Skip Perf build"
		return 0
	fi

	log_section_start "Build Perf"

	cd tools/perf

	_make O="${VIRTME_PERF_DIR}" DESTDIR=/usr install || rc=${?}

	cd "${KERNEL_SRC}"

	log_section_end

	return ${rc}
}

build() {
	if [ "${INPUT_BUILD_SKIP}" = 1 ]; then
		printinfo "Skip kernel build"
		return 0
	fi

	build_kernel
	if [ "${EXPECT}" = 0 ] && with_clang; then
		build_compile_commands || true # nice to have
	fi
	install_kernel_headers
	build_perf
}

build_selftests() { local rc=0
	if [ "${INPUT_BUILD_SKIP_SELFTESTS}" = 1 ]; then
		printinfo "Skip selftests build"
		return 0
	fi

	log_section_start "Build the selftests $(basename "${SELFTESTS_DIR}")"

	_make_o KHDR_INCLUDES="-I${VIRTME_HEADERS_DIR}/include" -C "${SELFTESTS_DIR}" || rc=${?}

	log_section_end

	return ${rc}
}

build_bpftests() { local rc=0
	if [ "${INPUT_BUILD_SKIP_BPFTESTS}" = 1 ]; then
		printinfo "Skip bpftests build"
		return 0
	fi

	log_section_start "Build BPFTests"

	_make_o KHDR_INCLUDES="-I${VIRTME_HEADERS_DIR}/include" -C "${BPFTESTS_DIR}" || rc=${?}

	log_section_end

	return ${rc}
}

build_packetdrill() { local old_pwd kversion branch rc=0
	if [ "${INPUT_BUILD_SKIP_PACKETDRILL}" = 1 ]; then
		printinfo "Skip Packetdrill build"
		return 0
	fi

	log_section_start "Build Packetdrill"

	old_pwd="${PWD}"

	# make sure we have the last stable tests
	cd /opt/packetdrill/
	if [ "${INPUT_PACKETDRILL_NO_SYNC}" = "1" ]; then
		printinfo "Packetdrill: no sync"
	else
		git fetch origin

		branch="${PACKETDRILL_GIT_BRANCH}"
		if [ "${INPUT_PACKETDRILL_STABLE}" = "1" ]; then
			kversion="mptcp-${KVER_MAJ}.${KVER_MIN}"
			# set the new branch only if it exists. If not, take the dev one
			if git show-ref --quiet "refs/remotes/origin/${kversion}"; then
				branch="${kversion}"
			fi
		fi
		git checkout -f "origin/${branch}"
	fi
	cd gtests/net/packetdrill/
	./configure
	_make || rc=${?}

	if [ "${INPUT_PACKETDRILL_NO_MORE_TOLERANCE}" = "1" ]; then
		printinfo "Packetdrill: not modifying the tolerance"
	else
		cd ../mptcp
		# reduce debug logs: too much
		set_trace_off

		local pf val new_val
		for pf in $(git grep -l "^--tolerance_usecs="); do
			# shellcheck disable=SC2013 # to filter duplicated ones
			for val in $(grep "^--tolerance_usecs=" "${pf}" | cut -d= -f2 | sort -u); do
				if [ "${mode}" = "debug" ]; then
					# Increase tolerance in debug mode:
					# the environment can be very slow
					new_val=$((val * 8))
				else
					# Triple the time in normal mode:
					# public CI can be quite loaded...
					new_val=$((val * 3))
				fi

				sed -i "s/^--tolerance_usecs=${val}$/--tolerance_usecs=${new_val}/g" "${pf}"
			done
		done

		set_trace_on
	fi
	cd "${old_pwd}"

	log_section_end

	return ${rc}
}

prepare() { local mode no_tap=1
	mode="${1}"

	printinfo "Prepare the environment"

	build_selftests
	if [ "${mode}" = "btf" ]; then
		build_bpftests
	fi
	build_packetdrill

	if is_ci; then
		no_tap=0 # we want subtests
	fi

	cat <<EOF > "${BASH_PROFILE}"
export KERNEL_BUILD_DIR="${VIRTME_BUILD_DIR}"
export KERNEL_SRC_DIR="${KERNEL_SRC}"
export PATH="\${PATH}:${VIRTME_TOOLS_SBIN_DIR}"
EOF

	cat <<EOF > "${VIRTME_SCRIPT}"
#! /bin/bash

if [ "${INPUT_TRACE}" = "1" ]; then
	set -x
fi

# useful for virtme-exec-run
TAP_PREFIX="${KERNEL_SRC}/tools/testing/selftests/kselftest/prefix.pl"
RESULTS_DIR="${RESULTS_DIR}"
OUTPUT_VIRTME="${OUTPUT_VIRTME}"
KUNIT_CORE_LOADED=0
MAX_THREADS=${INPUT_MAX_THREADS:-$((INPUT_CPUS * 2))}
export SELFTESTS_MPTCP_LIB_EXPECT_ALL_FEATURES="${INPUT_SELFTESTS_MPTCP_LIB_EXPECT_ALL_FEATURES}"
export SELFTESTS_MPTCP_LIB_OVERRIDE_FLAKY="${INPUT_SELFTESTS_MPTCP_LIB_OVERRIDE_FLAKY}"
export SELFTESTS_MPTCP_LIB_COLOR_FORCE="${INPUT_SELFTESTS_MPTCP_LIB_COLOR_FORCE}"
export SELFTESTS_MPTCP_LIB_NO_TAP="${no_tap}"

set_max_threads() {
	# if QEmu without KVM support
	if [ "${mode}" == "debug" ] ||
	   { [ "\$(cat /sys/devices/virtual/dmi/id/sys_vendor)" = "QEMU" ] &&
	     [ "\$(cat /sys/devices/system/clocksource/clocksource0/current_clocksource)" != "kvm-clock" ]; }; then
		MAX_THREADS=$((MAX_THREADS / 2)) # avoid too many concurrent work
	fi
}

if [ "${GITHUB_ACTIONS}" = "true" ]; then
	# \$1: description
	log_section_start() {
		echo -e "\n::group::${COLOR_YELLOW}\${*}${COLOR_RESET}"
	}

	log_section_end() {
		echo -e "::endgroup::\n"
	}
else
	# \$1: description
	log_section_start() {
		echo -e "${COLOR_BLUE}\${*}${COLOR_RESET}"
	}

	log_section_end() {
		true
	}
fi

# \$1: name of the test
_can_run() { local tname
	tname="\${1}"

	# only some tests?
	if [ -n "${INPUT_RUN_TESTS_ONLY}" ]; then
		if ! echo "${INPUT_RUN_TESTS_ONLY}" | grep -wq "\${tname}"; then
			return 1
		fi
	fi

	# not some tests?
	if [ -n "${INPUT_RUN_TESTS_EXCEPT}" ]; then
		if echo "${INPUT_RUN_TESTS_EXCEPT}" | grep -wq "\${tname}"; then
			return 1
		fi
	fi

	return 0
}

can_run() {
	# Use the function name of the caller without the prefix
	_can_run "\${FUNCNAME[1]#*_}"
}

# \$1: file ; \$2+: commands
_tap() { local out out_subtests tmp fname rc ok nok msg cmt ts_s_start ts_s_stop
	out="\${1}.tap"
	out_subtests="\${1}_subtests.tap"
	fname="\$(basename \${1})"
	shift

	rm -f "\${out}" "\${out_subtests}"
	# With TAP, we have first the summary, then the diagnostic
	tmp="\${out}.tmp"
	ok="ok 1 test: \${fname}"
	nok="not \${ok}"
	ts_s_start=\$(date +%s)

	# init
	{
		echo "TAP version 13"
		echo "1..1"
	} | tee "\${out}"

	# Exec the command and pipe in tap prefix + store for later
	"\${@}" 2>&1 | "\${TAP_PREFIX}" | tee "\${tmp}"
	# output to stdout now to see the progression
	rc=\${PIPESTATUS[0]}
	ts_s_stop=\$(date +%s)

	# summary
	case \${rc} in
		0)
			msg="\${ok}"
			;;
		1)
			msg="\${nok}"
			cmt=FAIL
			;;
		2)
			msg="\${nok}"
			cmt=XFAIL
			;;
		3)
			msg="\${nok}"
			cmt=XPASS
			;;
		4)
			cmt=SKIP
			if [ "\${SELFTESTS_MPTCP_LIB_EXPECT_ALL_FEATURES}" = "1" ]; then
				msg="\${nok}"
			else
				msg="\${ok}"
			fi
			;;
		*)
			msg="\${nok}"
			cmt="FAIL # exit=\${rc}"
			;;
	esac
	# note: '#' is a directive, not a comment: we imitate kselftest/runner.sh
	echo "\${msg}\${cmt+ # }\${cmt}" | tee -a "\${out}"

	# diagnostic at the end with TAP
	# Strip colours: https://stackoverflow.com/a/18000433
	# Also extract subtests displayed at the end, if any, in a different file without "#"
	sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2};?)?)?[mGK]//g" "\${tmp}" | \
		awk "BEGIN { subtests=0 } {
			if (subtests == 0 && \\\$0 ~ /^# TAP version /) { subtests=1 };
			if (subtests == 0) { print >> \"\${out}\" }
			else { for (i=2; i <= NF; i++) printf(\"%s\", ((i>2) ? OFS : \"\") \\\$i) >> \"\${out_subtests}\" ; printf(\"\n\") >> \"\${out_subtests}\" }
		}"
	rm -f "\${tmp}"

	echo "# time=\$((ts_s_stop - ts_s_start))" | tee -a "\${out}"

	return \${rc}
}

# \$1: kunit path ; \$2: kunit test
_kunit_result() {
	if ! grep -q "^KTAP" "\${1}" 2>/dev/null; then
		echo "TAP version 14"
		echo "1..1"
	fi

	if ! cat "\${1}"; then
		echo "not ok 1 test: \${2} # no kunit result"
		return 1
	fi
}

run_kunit_core() {
	[ "\${KUNIT_CORE_LOADED}" = 1 ] && return 0
	KUNIT_CORE_LOADED=1

	_tap "${RESULTS_DIR}/kunit" insmod ${VIRTME_BUILD_DIR}/lib/kunit/kunit.ko
}

# \$1: .ko path
run_kunit_one() { local ko kunit kunit_path rc=0
	ko="\${1}"

	kunit="\${ko#${VIRTME_BUILD_DIR}/}" # remove abs dir
	kunit="\${kunit:10:-8}" # remove net/mptcp (10) + _test.ko (8)
	kunit="\${kunit//_/-}" # dash
	kunit_path="/sys/kernel/debug/kunit/\${kunit}/results"

	log_section_start "KUnit Test: \${kunit}"

	run_kunit_core || return \${?}

	insmod "\${ko}" || true # errors will also be visible below: no results
	_kunit_result "\${kunit_path}" "\${kunit}" | tee "${RESULTS_DIR}/kunit_\${kunit}.tap" || rc=\${?}

	log_section_end

	return \${rc}
}

run_kunit_all() { local ko rc=0
	can_run || return 0

	cd "${KERNEL_SRC}"

	for ko in ${VIRTME_BUILD_DIR}/net/mptcp/*_test.ko; do
		run_kunit_one "\${ko}" || rc=\${?}
	done

	return \${rc}
}

# \$1: output tap file; rest: command to launch
_run_selftest_one_tap() {
	cd "${KERNEL_SRC}/${SELFTESTS_DIR}"
	_tap "\${@}"
}

# \$1: script file; rest: command to launch
run_selftest_one() { local sf tap rc=0
	sf=\$(basename \${1})
	tap=selftest_\${sf:0:-3}
	shift

	_can_run "\${tap}" || return 0

	log_section_start "Selftest Test: ./\${sf}\${1:+ \${*}}"
	_run_selftest_one_tap "${RESULTS_DIR}/\${tap}" "./\${sf}" "\${@}" || rc=\${?}
	log_section_end

	return \${rc}
}

run_selftest_all() { local sf rc=0
	# The following command re-do a slow headers install + compilation in a different dir
	#make O="${VIRTME_BUILD_DIR}" --silent -C tools/testing/selftests TARGETS=net/mptcp run_tests

	for sf in "${KERNEL_SRC}/${SELFTESTS_DIR}/"*.sh; do
		if [ -x "\${sf}" ]; then
			run_selftest_one "\${sf}" || rc=\${?}
		fi
	done

	return \${rc}
}

_run_mptcp_connect_opt() { local t="mptcp_connect_\${1}" rc=0
	shift

	log_section_start "Selftest Test: ./mptcp_connect.sh \${*}"
	MPTCP_LIB_KSFT_TEST=\${t} _run_selftest_one_tap "${RESULTS_DIR}/\${t}" ./mptcp_connect.sh "\${@}" || rc=\${?}
	log_section_end

	return \${rc}
}

run_mptcp_connect_mmap() {
	can_run || return 0

	_run_mptcp_connect_opt mmap -m mmap
}

# \$1: packetdrill TAP file, \$2: TAP prefix
_packetdrill_result() {
	if grep -q "^TAP version 13" "\${1}" 2>/dev/null; then
		sed -i "s#\${PWD}/#packetdrill: #g" "\${1}" # remove long path + prefix
		return 0
	fi

	{
		echo "TAP version 13"
		echo "1..1"
		echo "not ok 1 test: \${2} # no result"
	} > "\${1}"

	return 1
}

# \$1: pktd_dir (e.g. mptcp/dss)
run_packetdrill_one() { local pktd_dir pktd tap rc=0
	pktd_dir="\${1}"
	pktd="\$(basename "\${pktd_dir}" ".pkt")" # remove ext just in case
	tap="packetdrill_\${pktd}"

	if [ "\${pktd}" = "common" ]; then
		return 0
	fi

	_can_run "\${tap}" || return 0

	log_section_start "Packetdrill Test: \${pktd}"
	cd /opt/packetdrill/gtests/net/
	PYTHONUNBUFFERED=1 ./packetdrill/run_all.py -t "${RESULTS_DIR}" \
		-l -v -P \${MAX_THREADS} \${pktd_dir} || rc=\${?}
	_packetdrill_result "${RESULTS_DIR}/\${tap}.tap" "\${tap}" || rc=\${?}
	log_section_end

	return \${rc}
}

run_packetdrill_all() { local pktd_dir rc=0
	cd /opt/packetdrill/gtests/net/

	# dry run just to "heat" up the environment: the first tests are always
	# slower, especially with a debug kernel
	./packetdrill/run_all.py mptcp/add_addr/add_addr4_server.pkt &>/dev/null || true

	for pktd_dir in mptcp/*; do
		run_packetdrill_one "\${pktd_dir}" || rc=\${?}
	done

	return \${rc}
}

# \$1: output tap file; rest: command to launch
_run_bpftest_one_tap() {
	cd "${VIRTME_BUILD_DIR}"
	_tap "\${@}"
}

# \$1: script file; rest: command to launch
run_bpftest_one() { local bf bt tap rc=0
	bf=\$(basename \${1})
	bt=\${2}
	tap=bpftest_\${bf}_\${bt}

	log_section_start "BPF Test: \${bf} -t \${bt}"
	_run_bpftest_one_tap "${RESULTS_DIR}/\${tap}" "./\${bf}" -t "\${bt}" || rc=\${?}
	log_section_end

	return \${rc}
}

run_bpftest_all() {
	can_run || return 0

	if [ "${mode}" = "btf" ]; then
		local sf rc=0

		for sf in "${VIRTME_BUILD_DIR}/"test_progs*; do
			if [ -x "\${sf}" ]; then
				run_bpftest_one "\${sf}" mptcp || rc=\${?}
			fi
		done

		return \${rc}
	else
		echo "Skip BPF tests: only supported in the 'btf' mode"
	fi
}

run_all() {
	run_kunit_all
	run_selftest_all
	run_mptcp_connect_mmap
	run_packetdrill_all
	run_bpftest_all
}

has_call_trace() {
	grep -q "[C]all Trace:" "${OUTPUT_VIRTME}"
}

kmemleak_scan() {
	if [ "${mode}" = "debug" ]; then
		echo scan > /sys/kernel/debug/kmemleak
		cat /sys/kernel/debug/kmemleak > "${KMEMLEAK}"
	fi
}

# \$1: max iterations (<1 means no limit) ; args: what needs to be executed
run_loop_n() { local i tdir rc=0
	n=\${1}
	shift

	tdir="${KERNEL_SRC}/${SELFTESTS_DIR}"
	if ls "\${tdir}/"*.pcap &>/dev/null; then
		mkdir -p "\${tdir}/pcaps"
		mv "\${tdir}/"*.pcap "\${tdir}/pcaps"
	fi

	i=1
	while true; do
		echo -e "\n\n\t=== ${COLOR_BLUE}Attempt: \${i} (\$(date -R))${COLOR_RESET} ===\n\n"

		if ! "\${@}" || has_call_trace; then
			rc=1

			echo -e "\n\n\t=== ${COLOR_RED}ERROR after \${i} attempts (\$(date -R))${COLOR_RESET} ===\n\n"

			if [ "${INPUT_RUN_LOOP_CONTINUE}" = "1" ]; then
				echo "Attempt: \${i}" >> "${CONCLUSION}.failed"
			else
				break
			fi
		fi

		rm -f "\${tdir}/"*.pcap 2>/dev/null

		if [ "\${i}" = "\${n}" ]; then
			break
		fi

		i=\$((i+1))
	done

	echo -e "\n\n\t${COLOR_BLUE}Stopped after \${i} attempts${COLOR_RESET}\n\n"

	return "\${rc}"
}

# args: what needs to be executed
run_loop() {
	run_loop_n 0 "\${@}"
}

set_max_threads

# To run commands before executing the tests
if [ -f "${VIRTME_EXEC_PRE}" ]; then
	source "${VIRTME_EXEC_PRE}"
	# e.g.:
	# echo "file net/mptcp/* +fmp" > /sys/kernel/debug/dynamic_debug/control
	# echo __mptcp_subflow_connect > /sys/kernel/tracing/set_graph_function
	# echo printk > /sys/kernel/tracing/set_graph_notrace
	# echo function_graph > /sys/kernel/tracing/current_tracer
fi

# To exec different tests than the full suite
if [ -f "${VIRTME_EXEC_RUN}" ]; then
	echo -e "\n\n\t${COLOR_YELLOW}Not running all tests but:${COLOR_RESET}\n\n-------- 8< --------\n\$(sed "s/#.*//g;/^\s*$/d" "${VIRTME_EXEC_RUN}")\n-------- 8< --------\n\n"
	source "${VIRTME_EXEC_RUN}"
	# e.g.:
	# run_selftest_one ./mptcp_join.sh -f
	# run_loop run_selftest_one ./simult_flows.sh
	# run_packetdrill_one mptcp/dss
else
	run_all
fi

cd "${KERNEL_SRC}"

kmemleak_scan

# To run commands before executing the tests
if [ -f "${VIRTME_EXEC_POST}" ]; then
	source "${VIRTME_EXEC_POST}"
	# e.g.: cat /sys/kernel/tracing/trace
fi

# end
echo "${VIRTME_SCRIPT_END}"
EOF
	chmod +x "${VIRTME_SCRIPT}"

	if [ -f "${VIRTME_PREPARE_POST}" ]; then
		# shellcheck source=/dev/null
		source "${VIRTME_PREPARE_POST}"
	fi
}

run() {
	printinfo "Run the virtme script: manual"

	"${VIRTME_RUN}" "${VIRTME_RUN_OPTS[@]}"
}

run_expect() {
	local timestamps_sec_stop

	if is_ci; then
		timestamps_sec_stop=$(date +%s)

		# max - compilation time - before/after script
		VIRTME_EXPECT_TEST_TIMEOUT=$((INPUT_CI_TIMEOUT_SEC - (timestamps_sec_stop - TIMESTAMPS_SEC_START) - VIRTME_CI_ESTIMATED_EXTRA_TIME))
	else
		# disable timeout
		VIRTME_EXPECT_TEST_TIMEOUT="${INPUT_EXPECT_TIMEOUT}"
	fi

	# force a stop in case of panic, but avoid a reboot in "expect" mode
	VIRTME_RUN_OPTS+=(--kopt panic=-1 --qemu-opts -no-reboot)

	printinfo "Run the virtme script: expect (timeout: ${VIRTME_EXPECT_TEST_TIMEOUT})"

	cat <<EOF > "${VIRTME_RUN_SCRIPT}"
#! /bin/bash
echo -e "$(log_section_start "Boot VM")"
set -x
"${VIRTME_RUN}" ${VIRTME_RUN_OPTS[@]} 2>&1 | tr -d '\r'
EOF
	chmod +x "${VIRTME_RUN_SCRIPT}"

	cat <<EOF > "${VIRTME_RUN_EXPECT}"
#!/usr/bin/expect -f

set timeout "${VIRTME_EXPECT_BOOT_TIMEOUT}"
spawn "${VIRTME_RUN_SCRIPT}"
expect {
	"virtme-ng-init: initialization done\r" {
		send_user "Waiting for the console to be ready\n"
		send "\r"
	} timeout {
		send_user "\n$(log_section_end)"
		send_user "Timeout virtme-ng-init: stopping\n"
		exit 1
	} eof {
		send_user "\n$(log_section_end)"
		send_user "${VIRTME_SCRIPT_UNEXPECTED_STOP} (ttyS0)\n"
		exit 1
	}
}

set timeout "1"

for {set i 0} {\$i < 60} {incr i 1} {
	expect {
		"root@" {
			send_user "\n$(log_section_end)"
			send_user "Starting the validation script (after \$i sec)\n"
			break
		} timeout {
			sleep 1
			send "\r"
		} eof {
			send_user "\n$(log_section_end)"
			send_user "${VIRTME_SCRIPT_UNEXPECTED_STOP} (console)\n"
			exit 1
		}
	}
}

if {\$i >= 60} {
	send_user "\n$(log_section_end)"
	send_user "Timeout console: stopping (\$i)\n"
	exit 1
}

set timeout "${VIRTME_EXPECT_TEST_TIMEOUT}"
send -- "stdbuf -oL ${VIRTME_SCRIPT}\r"

expect {
	"${VIRTME_SCRIPT_END}\r" {
		send_user "validation script ended with success\n"
	} timeout {
		send_user "\n$(log_section_end)"
		send_user "Timeout: sending Ctrl+C\n"
		send "\x03\r"
		sleep 2
		send "\x03\r"
	} eof {
		send_user "${VIRTME_SCRIPT_UNEXPECTED_STOP}\n"
		exit 1
	}
}
send -- "/usr/lib/klibc/bin/poweroff\r"

expect eof
EOF
	chmod +x "${VIRTME_RUN_EXPECT}"

	# We could use "--script-sh", but we use expect to catch timeout, etc.
	"${VIRTME_RUN_EXPECT}" | tee "${OUTPUT_VIRTME}"
}

ccache_stat() {
	if is_ci; then
		log_section_start "CCache Stats"
		ccache -s
		log_section_end
	fi
}

# $1: category ; $2: mode ; $3: reason
_register_issue() { local msg
	# only one mode in CI mode
	if is_ci; then
		msg="${1}: ${3}"
	else
		msg="${1} ('${2}' mode): ${3}"
	fi

	if [ "${#EXIT_REASONS[@]}" -eq 0 ]; then
		EXIT_REASONS=("${msg}")
	else
		EXIT_REASONS+=("-" "${msg}")
	fi
}

_had_issues() {
	[ ${#EXIT_REASONS[@]} -gt 0 ]
}

_had_critical_issues() {
	echo "${EXIT_REASONS[*]}" | grep -q "Critical"
}

# $1: end critical ; $2: end unstable
_print_issues() {
	echo -n "${EXIT_REASONS[*]} "
	if _had_critical_issues; then
		echo "${1}"
	else
		echo "${2}"
	fi
}

_has_call_trace() {
	grep -q "Call Trace:" "${OUTPUT_VIRTME}"
}

_print_line() {
	echo "=========================================="
}

decode_stacktrace() {
	./scripts/decode_stacktrace.sh "${VIRTME_BUILD_DIR}/vmlinux" "${KERNEL_SRC}" "${VIRTME_BUILD_DIR}/.virtme_mods"
}

_print_call_trace_info() {
	echo
	_print_line
	echo "Call Trace:"
	_print_line
	grep --text -C 80 "Call Trace:" "${OUTPUT_VIRTME}" | decode_stacktrace
	_print_line
	echo "Call Trace found"
}

_get_call_trace_status() {
	echo "$(grep -c "Call Trace:" "${OUTPUT_VIRTME}") Call Trace(s)"
}

_has_unexpected_stop() {
	grep -q "${VIRTME_SCRIPT_UNEXPECTED_STOP}" "${OUTPUT_VIRTME}"
}

_print_unexpected_stop() {
	echo
	_print_line
	echo "${VIRTME_SCRIPT_UNEXPECTED_STOP}: see above"
}

_has_timed_out() {
	! grep -q "${VIRTME_SCRIPT_END}" "${OUTPUT_VIRTME}"
}

_print_timed_out() {
	echo
	_print_line
	echo "Timeout:"
	_print_line
	tail -n 20 "${OUTPUT_VIRTME}"
	_print_line
	echo "Global Timeout"
}

_has_kmemleak() {
	[ -s "${KMEMLEAK}" ]
}

_print_kmemleak() {
	echo
	_print_line
	echo "KMemLeak:"
	_print_line
	decode_stacktrace < "${KMEMLEAK}"
	_print_line
	echo "KMemLeak detected"
}

# $1: mode, rest: args for kconfig
_print_summary_header() {
	local mode="${1}"
	shift

	echo "== Summary =="
	echo
	echo "Ref: ${GITHUB_REF_NAME:-${CIRRUS_TAG:-$(git describe --tags 2>/dev/null || git rev-parse --short HEAD 2>/dev/null || echo "Unknown")}}${GITHUB_SHA:+ (${GITHUB_SHA})}"
	echo "Mode: ${mode}"
	echo "Extra kconfig: ${*:-/}"
	echo
}

# [ $1: .tap file, summary file by default]
_has_failed_tests() {
	grep -q "^not ok " "${1:-${TESTS_SUMMARY}}"
}

# $1: prefix
_print_tests_results_subtests() { local tap ok
	for tap in "${RESULTS_DIR}/${1}"*.tap; do
		[[ "${tap}" = *"_*.tap" ]] && continue
		grep -q "^not ok " "${tap}" && ok="not ok" || ok="ok"
		echo "${ok} 1 test: $(basename "${tap}" ".tap")"
	done
}

_print_tests_result() { local flaky
	echo "All tests:"
	# only from the main tests
	grep --text --no-filename -E "^(not )?ok 1 test: " "${RESULTS_DIR}"/*.tap || true
	_print_tests_results_subtests "kunit_"
	_print_tests_results_subtests "packetdrill_"

	if is_ci; then
		flaky="$(grep --text --no-filename -F " # IGNORE Flaky" "${RESULTS_DIR}"/*_subtests.tap || true)"
	else
		flaky="$(grep --text --no-filename -F "[IGNO] (flaky)" "${RESULTS_DIR}"/*.tap || true)"
	fi
	if [ -n "${flaky}" ]; then
		echo
		echo "Flaky tests:"
		echo "${flaky}"
	fi
}

_print_failed_tests() { local t
	echo
	_print_line
	echo "Failed tests:"
	for t in "${RESULTS_DIR}"/*.tap; do
		if _has_failed_tests "${t}"; then
			_print_line
			echo "- $(basename "${t}"):"
			echo
			grep -av "^ok [0-9]\+ " "${t}"
		fi
	done
	_print_line
}

_get_failed_tests() {
	# not ok 1 test: selftest_mptcp_join.tap # exit=1
	# we just want the main results, not the detailed ones for the moment
	grep --text "^not ok 1 test: " "${TESTS_SUMMARY}" | \
		awk '{ print $5 }' | \
		sort -u | \
		sed "s/\.tap$//g"
}

_get_failed_tests_status() { local t fails=()
	for t in $(_get_failed_tests); do
		fails+=("${t}")
	done

	echo "${#fails[@]} failed test(s): ${fails[*]}"
}

_gen_results_files() {
	LANG=C tap2junit "${RESULTS_DIR}"/*.tap

	# remove prefix id (unique test) and comments (status, time)
	sed -i 's/\(<testcase name="\)[0-9]\+[ -]*/\1/g;/<testcase name=/s/\s\+#.*">/">/g' "${RESULTS_DIR}"/*.tap.xml

	LANG=C /tap2json.py \
		--output "${RESULTS_DIR}/results.json" \
		--info "run_id:${GITHUB_RUN_ID:-"none"}" \
		--only-fails \
		"${RESULTS_DIR}"/*.tap
}

# $1: mode, rest: args for kconfig
analyze() {
	# reduce log that could be wrongly interpreted
	set_trace_off

	local mode="${1}"
	shift

	printinfo "Analyze results"

	if is_ci; then
		_gen_results_files || true
	fi

	echo -ne "\n${COLOR_GREEN}"
	_print_summary_header "${mode}" "${@}" | tee "${TESTS_SUMMARY}"
	_print_tests_result | tee -a "${TESTS_SUMMARY}"

	echo -ne "${COLOR_RESET}\n${COLOR_RED}"

	if _has_failed_tests; then
		# no tee, it can be long and less important than critical err
		_print_failed_tests >> "${TESTS_SUMMARY}"
		_register_issue "Unstable" "${mode}" "$(_get_failed_tests_status)"
		EXIT_STATUS=42
	fi

	# look for crashes/warnings
	if _has_call_trace; then
		_print_call_trace_info | tee -a "${TESTS_SUMMARY}"
		_register_issue "Critical" "${mode}" "$(_get_call_trace_status)"
		EXIT_STATUS=1

		if is_ci; then
			zstd -19 -T0 "${VIRTME_BUILD_DIR}/vmlinux" \
			     -o "${RESULTS_DIR}/vmlinux.zstd"
		fi
	fi

	if _has_unexpected_stop; then
		_print_unexpected_stop | tee -a "${TESTS_SUMMARY}"
		_register_issue "Critical" "${mode}" "${VIRTME_SCRIPT_UNEXPECTED_STOP}"
		EXIT_STATUS=1
	elif _has_timed_out; then
		_print_timed_out | tee -a "${TESTS_SUMMARY}"
		_register_issue "Critical" "${mode}" "Global Timeout"
		EXIT_STATUS=1
	fi

	if _has_kmemleak; then
		_print_kmemleak | tee -a "${TESTS_SUMMARY}"
		_register_issue "Critical" "${mode}" "KMemLeak"
		EXIT_STATUS=1
	fi

	echo -ne "${COLOR_RESET}"

	if [ "${EXIT_STATUS}" = "1" ]; then
		echo
		printerr "Critical issue(s) detected, exiting"
		exit 1
	fi

	set_trace_on
}

# $@: args for kconfig
prepare_all() { local t mode
	t=${1}; shift
	mode="${1}"

	printinfo "Start: ${t} (${mode})"

	setup_env "${mode}"
	gen_kconfig "${@}"
	build
	prepare "${mode}"
}

# $1: mode ; [ $2+: kconfig ]
go_manual() {
	prepare_all manual "${@}"
	run
}

# $1: mode ; [ $2+: kconfig ]
go_expect() {
	EXPECT=1

	ccache_stat
	check_last_iproute
	check_source_exec_all

	prepare_all auto "${@}"
	ccache_stat

	run_expect
	analyze "${@}"
}

static_analysis() { local src obj ftmp
	ftmp=$(mktemp)

	for src in net/mptcp/*.c; do
		obj="${src/%.c/.o}"
		if [[ "${src}" = *"_test.mod.c" ]]; then
			continue
		fi

		printinfo "Checking: ${src}"

		touch "${src}"
		if ! KCFLAGS="-Werror" _make_o W=1 "${obj}"; then
			printerr "Found make W=1 issues for ${src}"
		fi

		touch "${src}"
		_make_o C=1 "${obj}" >/dev/null 2>"${ftmp}" || true

		if test -s "${ftmp}"; then
			cat "${ftmp}"
			printerr "Found make C=1 issues for ${src}"
		fi
	done

	rm -f "${ftmp}"
}

print_conclusion() { local rc=${1}
	echo -n "${EXIT_TITLE}: "

	if _had_issues; then
		_print_issues "❌" "🔴"
	elif [ "${rc}" != "0" ]; then
		echo "Script error! ❓"
	else
		echo "Success! ✅"
	fi
}

exit_trap() { local rc=${?}
	set +x

	echo -ne "\n${COLOR_BLUE}"
	if [ "${EXPECT}" = 1 ]; then
		print_conclusion ${rc} | tee "${CONCLUSION:-"conclusion.txt"}"
	fi
	echo -e "${COLOR_RESET}"

	return ${rc}
}

usage() {
	echo "Usage: ${0} <manual-normal | manual-debug | manual-btf | auto-normal | auto-debug | auto-btf | auto-all> [KConfig]"
	echo
	echo " - manual: access to an interactive shell"
	echo " - auto: the tests suite is ran automatically"
	echo
	echo " - normal: without the debug kconfig"
	echo " - debug: with debug kconfig"
	echo " - btf: without the debug kconfig, but with BTF support"
	echo " - all: both 'normal' and 'debug' modes"
	echo
	echo " - KConfig: optional kernel config: arguments for './scripts/config'"
	echo
	echo "Usage: ${0} <make [params] | make.cross [params] | build <mode> | defconfig <mode> | selftests | bpftests | cmd <command> | src <source file> | static | vm-manual | vm-auto >"
	echo
	echo " - make: run the make command with optional parameters"
	echo " - make.cross: run Intel's make.cross command with optional parameters"
	echo " - build: build everything, but don't start the VM ('normal' mode by default)"
	echo " - defconfig: only generate the .config file ('normal' mode by default)"
	echo " - selftests: only build the KSelftests"
	echo " - bpftests: only build the BPF tests"
	echo " - cmd: run the given command"
	echo " - src: source a given script file"
	echo " - static: run static analysis, with make W=1 C=1"
	echo " - vm-manual: start the VM with what has already been built ('normal' mode by default)"
	echo " - vm-auto: same, then run the tests as well ('normal' mode by default)"
	echo
	echo "This script needs to be ran from the root of kernel source code."
	echo
	echo "Some files can be added in the kernel sources to modify the tests suite."
	echo "See the README file for more details."
}


if [ -z "${INPUT_MODE}" ]; then
	set +x
	usage
	exit 0
fi

if [ ! -s "${SELFTESTS_CONFIG}" ]; then
	printerr "Please be at the root of kernel source code with MPTCP (Upstream) support"
	exit 1
fi


trap 'exit_trap' EXIT

case "${INPUT_MODE}" in
	"manual" | "normal" | "manual-normal")
		go_manual "normal" "${@}"
		;;
	"debug" | "manual-debug")
		go_manual "debug" "${@}"
		;;
	"btf" | "manual-btf")
		go_manual "btf" "${@}"
		;;
	"expect-normal" | "auto-normal")
		go_expect "normal" "${@}"
		;;
	"expect-debug" | "auto-debug")
		go_expect "debug" "${@}"
		;;
	"expect-btf" | "auto-btf")
		go_expect "btf" "${@}"
		;;
	"expect" | "all" | "expect-all" | "auto-all")
		# first with the minimum because configs like KASAN slow down the
		# tests execution, it might hide bugs
		_make_o -C "${SELFTESTS_DIR}" clean
		go_expect "normal" "${@}"
		_make_o clean
		go_expect "debug" "${@}"
		;;
	"make")
		_make_o "${@}"
		;;
	"make.cross")
		MAKE_CROSS="/usr/sbin/make.cross"
		wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O "${MAKE_CROSS}"
		chmod +x "${MAKE_CROSS}"
		COMPILER_INSTALL_PATH="${VIRTME_WORKDIR}/0day" \
			COMPILER="${COMPILER}" \
				"${MAKE_CROSS}" "${@}"
		;;
	"build")
		prepare_all manual "${@:-normal}"
		;;
	"defconfig")
		gen_kconfig "${@:-normal}"
		;;
	"selftests")
		build_selftests
		;;
	"bpftests")
		build_bpftests
		;;
	"cmd" | "command")
		"${@}"
		;;
	"src" | "source" | "script")
		if [ ! -f "${1}" ]; then
			printerr "No such file: ${1}"
			exit 1
		fi

		# shellcheck disable=SC1090
		source "${1}"
		;;
	"static" | "static-analysis")
		static_analysis
		;;
	"vm" | "vm-manual")
		setup_env "${@:-normal}"
		[ "${INPUT_PACKETDRILL_STABLE}" = "1" ] && build_packetdrill
		run
		;;
	"vm-expect" | "vm-auto")
		setup_env "${@:-normal}"
		[ "${INPUT_PACKETDRILL_STABLE}" = "1" ] && build_packetdrill
		run_expect
		analyze "${@:-normal}"
		;;
	*)
		set +x
		printerr "Unknown mode: ${INPUT_MODE}"
		echo -e "${COLOR_RED}"
		usage
		echo -e "${COLOR_RESET}"
		exit 1
esac

if is_ci && [ "${INPUT_CI_PRINT_EXIT_CODE}" = 1 ]; then
	set_trace_off
	echo "==EXIT_STATUS=${EXIT_STATUS}=="
else
	exit "${EXIT_STATUS}"
fi