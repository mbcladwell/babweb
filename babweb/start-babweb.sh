#!/bin/bash
PATH_INTO_STORE=abcdefgh
export LC_ALL="C"
mkdir -p /tmp/babweb/tmp/cache
mkdir -p /tmp/babweb/prv/session
art.in work --config=./conf/artanis.conf
