#!/bin/sh
set -eu

cd "${TF_ACTION_WORKING_DIR:-.}"
sh -c "terraform validate -no-color $*"

