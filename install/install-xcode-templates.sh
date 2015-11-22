# © 2015 George King. Permission to use this file is granted in license-qk.txt.

set -e

cd $(dirname "$0")/../xc-templates

dst_root="$HOME/Library/Developer/Xcode/Templates"

function install_templates {
  src_root="$1"
  find "$src_root" -name '*.xctemplate' | while read line; do
    src="$line"
    dst="$dst_root/${src/_Templates/ Templates}"
    echo "$src -> $dst"
    [[ -d "$dst" ]] && rm -rf "$dst"
    mkdir -p "$(dirname "$dst")"
    cp -R "$src" "$dst"
  done
}


install_templates "File_Templates"
install_templates "Project_Templates/QK"
