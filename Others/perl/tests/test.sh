#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

BINARY="perl"
BINARY_PATH="/usr/local/bin/perl"
WORKDIR=""

cleanup() {
    if [[ -n "${WORKDIR}" && -d "${WORKDIR}" ]]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

test_version() {
    local resolved output rc

    if ! command -v "${BINARY}" >/dev/null 2>&1; then
        printf 'FAIL: binary not found: %s\n' "${BINARY}" >&2
        return 1
    fi

    resolved="$(command -v "${BINARY}")"
    if [[ "${resolved}" != "${BINARY_PATH}" ]]; then
        printf 'FAIL: %s resolved to unexpected path: expected=<%s> actual=<%s>\n' \
            "${BINARY}" "${BINARY_PATH}" "${resolved}" >&2
        return 1
    fi

    if output="$("${BINARY}" -e 'printf "%vd", $^V' 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: version command exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${output}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${output}"
}

test_text_processing_file_roundtrip() {
    local script="${WORKDIR}/transform.pl"
    local infile="${WORKDIR}/input.txt"
    local outfile="${WORKDIR}/output.txt"
    local output rc actual_file
    local expected_stdout='lines=3 replacements=3'
    local expected_file

    cat > "${script}" <<'PERL'
use strict;
use warnings;

my ($in, $out) = @ARGV;

open my $in_fh, '<', $in or die "open $in: $!\n";
open my $out_fh, '>', $out or die "open $out: $!\n";

my $lines = 0;
my $replacements = 0;
while (my $line = <$in_fh>) {
    $lines++;
    $replacements += ($line =~ s/\bfoo\b/bar/g);
    print {$out_fh} $line;
}
close $out_fh or die "close $out: $!\n";

printf "lines=%d replacements=%d\n", $lines, $replacements;
PERL

    printf 'foo baz\nfoo foo\nqux\n' > "${infile}"

    if output="$("${BINARY}" "${script}" "${infile}" "${outfile}" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: text processing script exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${expected_stdout}" ]]; then
        printf 'FAIL: script summary mismatch: expected=<%s> actual=<%s>\n' \
            "${expected_stdout}" "${output}" >&2
        return 1
    fi

    if [[ ! -f "${outfile}" ]]; then
        printf 'FAIL: transformed file was not created: %s\n' "${outfile}" >&2
        return 1
    fi

    expected_file=$'bar baz\nbar bar\nqux'
    actual_file="$(< "${outfile}")"
    if [[ "${actual_file}" != "${expected_file}" ]]; then
        printf 'FAIL: transformed file content mismatch: expected=<%s> actual=<%s>\n' \
            "${expected_file}" "${actual_file}" >&2
        return 1
    fi

    printf 'PASS: text processing read/transform/write roundtrip\n'
}

test_core_module() {
    local output rc
    local expected='900150983cd24fb0d6963f7d28e17f72'

    if output="$("${BINARY}" -MDigest::MD5 -e 'print Digest::MD5::md5_hex("abc")' 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: Digest::MD5 invocation exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${expected}" ]]; then
        printf 'FAIL: Digest::MD5::md5_hex("abc") mismatch: expected=<%s> actual=<%s>\n' \
            "${expected}" "${output}" >&2
        return 1
    fi

    printf 'PASS: core module Digest::MD5 loaded from the installed perl: %s\n' "${output}"
}

test_zlib_linked_module() {
    local script="${WORKDIR}/zlib_roundtrip.pl"
    local output rc
    local expected='zlib-roundtrip-ok'

    cat > "${script}" <<'PERL'
use strict;
use warnings;

my $input = "openeuler-perl-zlib-roundtrip\n" x 8;

my $d = new Compress::Raw::Zlib::Deflate(-AppendOutput => 1, -Level => Z_BEST_COMPRESSION)
    or die "deflate init failed";
my $compressed = "";
my $st = $d->deflate($input, $compressed);
die "deflate failed: $st" unless $st == Z_OK;
$st = $d->flush($compressed);
die "flush failed: $st" unless $st == Z_OK;

my $i = new Compress::Raw::Zlib::Inflate()
    or die "inflate init failed";
my $out = "";
my $ist = $i->inflate($compressed, $out);
die "inflate failed: $ist" unless $ist == Z_OK || $ist == Z_STREAM_END;

print $out eq $input ? "zlib-roundtrip-ok" : "zlib-roundtrip-mismatch";
PERL

    if output="$("${BINARY}" -MCompress::Raw::Zlib "${script}" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: Compress::Raw::Zlib roundtrip exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${expected}" ]]; then
        printf 'FAIL: Compress::Raw::Zlib roundtrip mismatch: expected=<%s> actual=<%s>\n' \
            "${expected}" "${output}" >&2
        return 1
    fi

    printf 'PASS: Compress::Raw::Zlib deflate/inflate roundtrip (libz linked at runtime)\n'
}

test_bzip2_linked_module() {
    local script="${WORKDIR}/bzip2_roundtrip.pl"
    local output rc
    local expected='bzip2-roundtrip-ok'

    cat > "${script}" <<'PERL'
use strict;
use warnings;

my $input = "openeuler-perl-bzip2-roundtrip\n" x 8;

my ($bz, $st) = new Compress::Raw::Bzip2();
defined $bz or die "bzip2 init failed";
my $compressed = "";
$st = $bz->bzdeflate($input, $compressed);
die "bzdeflate failed: $st" unless $st == BZ_RUN_OK;
$st = $bz->bzclose($compressed);
die "bzclose failed: $st" unless $st == BZ_STREAM_END;

my ($ubz, $ust) = new Compress::Raw::Bunzip2();
defined $ubz or die "bunzip2 init failed";
my $out = "";
$ust = $ubz->bzinflate($compressed, $out);
die "bzinflate failed: $ust" unless $ust == BZ_OK || $ust == BZ_STREAM_END;

print $out eq $input ? "bzip2-roundtrip-ok" : "bzip2-roundtrip-mismatch";
PERL

    if output="$("${BINARY}" -MCompress::Raw::Bzip2 "${script}" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: Compress::Raw::Bzip2 roundtrip exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${expected}" ]]; then
        printf 'FAIL: Compress::Raw::Bzip2 roundtrip mismatch: expected=<%s> actual=<%s>\n' \
            "${expected}" "${output}" >&2
        return 1
    fi

    printf 'PASS: Compress::Raw::Bzip2 compress/uncompress roundtrip (libbz2 linked at runtime)\n'
}

test_gdbm_linked_module() {
    local script="${WORKDIR}/gdbm_roundtrip.pl"
    local dbfile="${WORKDIR}/data.gdbm"
    local output rc
    local expected='gdbm-roundtrip-ok'

    cat > "${script}" <<'PERL'
use strict;
use warnings;
use GDBM_File;

my $file = $ARGV[0];

my %write;
my $db = tie %write, 'GDBM_File', $file, GDBM_NEWDB, 0640
    or die "gdbm write tie failed: $GDBM_File::gdbm_errno";
$write{'alpha'} = 'one';
$write{'beta'} = 'two';
$db->sync;
untie %write;
undef $db;

my %read;
tie %read, 'GDBM_File', $file, GDBM_READER, 0
    or die "gdbm read tie failed: $GDBM_File::gdbm_errno";
my $ok = ($read{'alpha'} // '') eq 'one'
    && ($read{'beta'} // '') eq 'two'
    && scalar(keys %read) == 2;
untie %read;

print $ok ? "gdbm-roundtrip-ok" : "gdbm-roundtrip-mismatch";
PERL

    if output="$("${BINARY}" -MGDBM_File "${script}" "${dbfile}" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: GDBM_File roundtrip exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${expected}" ]]; then
        printf 'FAIL: GDBM_File roundtrip mismatch: expected=<%s> actual=<%s>\n' \
            "${expected}" "${output}" >&2
        return 1
    fi

    if [[ ! -f "${dbfile}" ]]; then
        printf 'FAIL: GDBM database file was not created: %s\n' "${dbfile}" >&2
        return 1
    fi

    printf 'PASS: GDBM_File write-then-read roundtrip (libgdbm linked at runtime)\n'
}

main() {
    local failures=0

    if ! WORKDIR="$(mktemp -d)"; then
        printf 'FAIL: cannot create temporary working directory\n' >&2
        return 1
    fi

    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_text_processing_file_roundtrip; then
        failures=$((failures + 1))
    fi
    if ! test_core_module; then
        failures=$((failures + 1))
    fi
    if ! test_zlib_linked_module; then
        failures=$((failures + 1))
    fi
    if ! test_bzip2_linked_module; then
        failures=$((failures + 1))
    fi
    if ! test_gdbm_linked_module; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
