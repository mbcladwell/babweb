#! /bin/bash
guix shell guile-next guile-ares-rs artanis -- guile -L . -L /home/mbc/projects/babweb -c '((@ (ares server) run-nrepl-server))'

