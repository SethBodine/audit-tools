#!/bin/sh
echo >&2 "This script must be sourced, not executed${1:+: }${1:-!}"
exit 1
