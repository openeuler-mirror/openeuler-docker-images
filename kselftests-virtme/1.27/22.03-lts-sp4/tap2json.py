#! /usr/bin/python3
# SPDX-License-Identifier: GPL-2.0
#
# Very simple TAP to JSON parser
#
# JQ can be used to filter tests later, e.g.abs
#    $ jq '.results.[] | select(.[].result == "fail")' results.json

import argparse
import json
import os
import re
import sys


def get_args_parser():
	parser = argparse.ArgumentParser(
		description="(Simple) TAP to JSON converter"
	)

	parser.add_argument(
		"--output",
		"-o",
		action="store",
		help="Output JSON file"
	)

	parser.add_argument(
		"--info",
		"-I",
		action="append",
		metavar="key:value",
		help="Add extra info in the JSON, can be used multiple times"
	)

	parser.add_argument(
		"--only-fails",
		"-f",
		action="store_true",
		help="Only keep failed tests"
	)

	parser.add_argument(
		"tapfiles",
		metavar="tapfiles",
		type=str,
		nargs="*",
		help="Input TAP file(s)"
	)

	return parser

# Same as in NIPA
TAP_RE = re.compile(r"(not )?ok (\d+)( -)? ([^#]*[^ ])( # )?([^ ].*)?$")

def parse_tap(tap, name, only_fails):
	results = {}
	has_results = False

	for line in tap:
		try:
			r = TAP_RE.match(line.rstrip()).groups()
		except AttributeError:
			continue

		has_results = True

		success = r[0] is None

		result = {
			'result': "pass" if success else "fail",
			'name': r[3]
		}

		if r[5]:
			result['comment'] = r[5]
			if success:
				if r[5].lower().startswith('skip'):
					result['result'] = "skip"
				elif r[5].lower().startswith('ignore flaky'):
					result['result'] = "flaky"

		if only_fails and result['result'] == "pass":
			continue

		results[r[1]] = result

	# just in case, to catch errors
	if not has_results:
		results[0] = {'result': "fail", 'name': name}

	return results


def parse_all_tap(tap_files, only_fails):
	results = {}

	for tap in tap_files:
		name = os.path.splitext(os.path.basename(tap))[0]
		with open(tap, "r", encoding="utf-8") as fd:
			result = parse_tap(fd.readlines(), name, only_fails)
			if result:
				results[name] = result

	return results

def add_info(results, infos):
	results = {
		"results": results
	}

	for info in infos:
		info = info.split(':', 1)
		if len(info) != 2:
			print("Skip info: " + info[0], file=sys.stderr)
			continue

		results[info[0]] = info[1]

	return results

def write_json(out_file, results):
	out = json.dumps(results)
	if out_file:
		with open(out_file, "w") as fd:
			fd.write(out)
	else:
		print(out)

if __name__ == "__main__":
	arg_parser = get_args_parser()
	args = arg_parser.parse_args()

	if not args.tapfiles:
		arg_parser.print_usage()
		sys.exit(1)

	results = parse_all_tap(args.tapfiles, args.only_fails)

	if args.info:
		results = add_info(results, args.info)

	write_json(args.output, results)