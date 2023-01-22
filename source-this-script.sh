#!/bin/sh
echo >&2 "This script must be sourced, not executed${1:+: run \". }$(basename "${1:-!}")${1:+\" instead.}"
exit 1
