# © 2015 George King. Permission to use this file is granted in license-qk.txt.

set -e

cd $(dirname "$0")/..

dst="$HOME/Library/Developer/Xcode/Templates/File Templates/Source"
mkdir -p "$dst"
cp -R templates/* "$dst"
