#! /bin/bash
export LC_ALL="C"
export GUILE_LOAD_PATH=guileloadpath
export GUILE_LOAD_COMPILED_PATH=guileloadcompiledpath
guileexecutable -L . -e '(babweb lib mastsodon)' -s $HOMEstorepath/share/guile/site/3.0/babweb/lib/mastodon.scm

