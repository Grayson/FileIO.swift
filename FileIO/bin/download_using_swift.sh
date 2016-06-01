#!/usr/bin/env bash

set -euo pipefail

USING_SWIFT_URL="https://github.com/Grayson/Using.swift.git"
SOURCE_PATH=$(cd $(dirname "${BASH_SOURCE}"); pwd)

function check_for_ext() {
	local root_path="$1"
	local ext_path="${root_path}/ext"
	mkdir -p "${ext_path}"
	echo "${ext_path}"
}

function download_using_swift() {
	local root="$1"
	cd "${root}"
	if [[ ! -d "Using.swift" ]]; then
		git clone "${USING_SWIFT_URL}"
	fi
}

function main() {
	local project_root="${PROJECT_DIR}"
	ext_path="$(check_for_ext "${project_root}")"
	download_using_swift "${ext_path}"
}

main "$@"