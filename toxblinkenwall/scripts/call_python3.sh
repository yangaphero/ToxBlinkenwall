#! /bin/bash

_dir=$(dirname "${0}")
_scr=$(basename "$0")
. "$_dir"/set_os_dir.sh
python3 "$_dir"/"$_OS_DIR_"/"$_scr"
