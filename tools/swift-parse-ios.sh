#!/usr/bin/env sh

set -e

header_files=$(find src -name *.h | xargs -L 1 echo -import-objc-header)
swift_files=$(find "$@" -name *.swift)

xcrun -sdk iphoneos \
swiftc -parse -target x86_64-apple-ios8.3 \
$header_files \
$swift_files
