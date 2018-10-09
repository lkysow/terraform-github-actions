#!/bin/sh
set -e

cd "${TF_ACTION_WORKING_DIR:-.}"
sh -c "terraform fmt -check=true -diff=true $*"

