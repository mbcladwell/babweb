
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
	     (srfi srfi-19) ;; date time
	     (srfi srfi-1)  ;;list searching; delete-duplicates in list 
	     (srfi srfi-9)  ;;records
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
(ice-9 binary-ports)
	     )

(string-append "touch /tmp/mcronfile-"
(number->string  (date-day (current-date))) "-"
(number->string  (date-hour (current-date))) "-"
(number->string  (date-minute (current-date))) "-"
(number->string  (date-second (current-date))) ".txt")




(job '(next-minute)
     (lambda () (system (string-append "touch /tmp/mcronfile-"
				       (number->string  (date-day (current-date))) "-"
				       (number->string  (date-hour (current-date))) "-"
				       (number->string  (date-minute (current-date))) "-"
				       (number->string  (date-second (current-date))) ".txt"))))


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


