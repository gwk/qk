#!/usr/bin/env sh

set -e

header_files=$(find "$@" -name *.h | xargs -L 1 echo -import-objc-header)
swift_files=$(find "$@" -name *.swift)

xcrun -sdk macosx   swiftc -parse -target x86_64-apple-macosx10.10 $header_files $swift_files
