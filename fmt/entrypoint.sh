#!/bin/sh
set -eu

# todo: clean up path
DIR=${TF_ACTION_WORKING_DIR:-.}
cd "$DIR"
sh -c "terraform fmt -check=true -diff=true $*"

