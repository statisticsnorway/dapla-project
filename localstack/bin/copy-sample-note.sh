#!/usr/bin/env bash

echo "Adding sample note to zeppelin"
cp -r "$(dirname $BASH_SOURCE)/testdata/notes/2F3KWDSR4" "$(dirname $BASH_SOURCE)/../notebook"
