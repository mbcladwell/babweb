
(add-to-load-path "/home/mbc/projects/babweb")
(add-to-load-path "/home/mbc/projects/babweb/babweb")
(add-to-load-path "/home/mbc/projects/guile-oauth")

(use-modules (web client)
	     (srfi srfi-19)   ;; date time
	     (srfi srfi-1)  ;;list searching; delete-duplicates in list 
	     (ice-9 pretty-print)
	     (ice-9 regex) ;;list-matches
	     (ice-9 string-fun)  ;;string-replace-substring	   
	     (ice-9 textual-ports)
	     (web client)
	     (srfi srfi-1)  ;;list searching; delete-duplicates in list 
	     (srfi srfi-9)  ;;records
	     (srfi srfi-28) ;;format
	     (web response)
	     (web request)
	     (oop goops) ;; class-of
	     (web uri)
	     (web client)
	     (web http)
	     (ice-9 rdelim)
	     (ice-9 i18n)   ;; internationalization
	     (ice-9 popen)
	     (ice-9 regex) ;;list-matches
	     (ice-9 receive)	     
	     (ice-9 string-fun)  ;;string-replace-substring
	     (ice-9 pretty-print)
	     (ice-9 readline)
	     (ice-9 format)
	     (json)
	     (gcrypt base64)
	     (oauth oauth1)
	     (oauth oauth2)
	     (oauth oauth2 request)
	     (oauth oauth2 response)
	     (oauth utils)
	     (oauth request)
	     (oauth oauth1 client)
	     (oauth oauth1 utils)
	     (oauth oauth1 credentials)
	     (oauth oauth1 signature)
	     (rnrs bytevectors)
	     (ice-9 textual-ports)
	    (rnrs bytevectors)
	    (gcrypt hmac)
	    (gcrypt base64)
	    (ice-9 iconv) ;;vector->string
	    ;;  (gnu)
	    (ebbot utilities)
	    (mcron job-specifier)

(ice-9 binary-ports)
)

(define *gpg-key* "babweb@build-a-bot.biz")
(define dir "/home/mbc/projects/babdata/bernays")

(define (get-envs2 dir)
  ;;returns a list
  (if (access?  (string-append dir "/envs") R_OK)
      (let* (
	    ;; (out-file (get-rand-file-name "f" "txt"))
	     (command  (string-append "gpg --decrypt " dir "/envs"))
	     (js (call-command-with-output-to-string command))
	    ;; (_ ((call-command-with-output-to-string command))
	    ;; (p  (open-input-file  (string-append dir "/" out-file)))
	    ;; (a (get-string-all p))
	   ;;  (_ (display js))
	    ;;  (b (json-string->scm  a))
	    ;; (_ (delete-file (string-append dir "/" out-file)))
	     (b (json-string->scm  js))
	     )
	(display b))
      (display "fail")))

(display "hellp")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (main)
  (let* ((start-time (current-time time-monotonic))	 
	 (stop-time (current-time time-monotonic))
	 
	 (elapsed-time (ceiling (time-second (time-difference stop-time start-time))))
	 )
    (begin
      (pretty-print (string-append "Shutting down after " (number->string elapsed-time) " seconds of use."))
      )))

(main)


