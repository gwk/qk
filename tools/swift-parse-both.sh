#!/usr/bin/env sh

set -e
$(dirname $0)/swift-parse-mac.sh "$@"
#$(dirname $0)/swift-parse-ios.sh "$@" # not yet supported.
