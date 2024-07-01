#!/bin/bash
PATH_INTO_STORE=babwebstorepath
export LC_ALL="C"
mkdir -p /var/tmp/babweb/tmp/cache
cd  $PATH_INTO_STORE/share/guile/site/3.0/babweb
art.in work -h0.0.0.0 --config=$HOME/.config/babweb/artanis.conf
