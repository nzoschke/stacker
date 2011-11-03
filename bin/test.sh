#!/bin/bash
source stacker.rc
set -x

with-temp -s <<EOF
pwd
touch foo
ls -al
EOF