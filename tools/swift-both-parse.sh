#!/usr/bin/env sh

set -ex

$(dirname $0)/swift-mac.sh -parse "$@"
#$(dirname $0)/swift-ios.sh -parse "$@" # not yet supported.
