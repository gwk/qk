#!/usr/bin/env sh

xcrun -sdk macosx   swiftc -target x86_64-apple-macosx10.10 "$@"
