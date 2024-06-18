#!/bin/bash
PATH_INTO_STORE=abcdefgh
export LC_ALL="C"
mkdir -p /tmp/babweb/tmp/cache
mkdir -p /tmp/babweb/prv/session
art.in work -h0.0.0.0 --config=/home/admin/.config/babweb/artanis.conf


