#!/bin/sh

# todo: clean up path
DIR=${TF_ACTION_WORKING_DIR:-.}
cd "$DIR"
sh -c "terraform fmt $*"

