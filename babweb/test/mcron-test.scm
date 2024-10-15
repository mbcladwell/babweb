
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
	    (mcron job-specifier)

(ice-9 binary-ports)
)

;; localtime
;;                        daylight-savings indicator tm:isdst (0 or ?)
;;  sec min hr d m y  dofw  dofy  tz-offset
;; #(57 25 15 9 9 124 3     282 1 14400 "EDT")
;; #(59 25 15 1 9 124 3     282 1 14400 "EDT")

(use-package-modules base idutils)

(string-append "touch /tmp/mcronfile-"
(number->string  (date-day (current-date))) "-"
(number->string  (date-hour (current-date))) "-"
(number->string  (date-minute (current-date))) "-"
(number->string  (date-second (current-date))) ".txt")



(job '(next-minute)
     (lambda ()
       (let* ((s (string-append        (number->string  (date-day (current-date))) "\t"
				       (number->string  (date-hour (current-date))) "\t"
				       (number->string  (date-minute (current-date))) "\t"
				       "cd ~/babdata/kazcin && ~/bin/masttoot.sh ~/babdata/kazcin >~/cronlog.log 2>&1" "\n"))
		(port (open-file "/home/mbc/.config/cron/mcron-out.txt" "a"))
				       )
		(begin
		(display s port)
		(close-port port))

)))




(job (lambda (current-time)
       (let* ((current-time (time-second (current-time)))
	      (next-month (next-month-from current-time));; (* 60 60 24 30) = 2592000 seconds
              (first-day (tm:wday (localtime next-month)))
              (second-sunday (if (eqv? first-day 0)
                                 7
                                 (- 14 first-day))))
        (+ next-month (* 24 60 60 second-sunday))
	 ))
     "my-program")

;;  sec min hr d m y          zone-offset
;; #(57 25 15 9 9 124 3 282 1 14400 "EDT")
;; #(59 25 15 1 9 124 3 282 1 14400 "EDT")

  (let* ((current-time (time-second (current-time)))
	 (_ (display (string-append "current-time: \n")))
	 (_ (pretty-print (localtime current-time)))
	 (next-month (next-month-from current-time))
	 (_ (display (string-append "next-month: \n")))
	 (_ (pretty-print (localtime next-month)))
         (first-day (tm:wday (localtime next-month)))
	 (_ (display (string-append "first-day: \n")))
	 (_ (pretty-print (localtime first-day)))
	 
         (second-sunday (if (eqv? first-day 0)
                            7
                            (- 14 first-day))))
      (+ next-month (* 24 60 60 second-sunday))
	 )

(localtime (time-second (current-time)))

;;;;every hour
;; (job '(next-minute-from (next-hour) '(3)) "masttoot.sh ~/babdata/bernays >~/mcronlog.log 2>&1") 

;; # m h  dom mon dow   command
;; 3 12,16,20 * * * /home/admin/bin/masttoot.sh ~/babdata/kazcin >/home/admin/cronlog.log 2>&1
;; 3 13,17,21 * * * /home/admin/bin/masttoot.sh ~/babdata/bernays >/home/admin/cronlog.log 2>&1
;; 3 14,15 * * * /home/admin/bin/masttoot.sh ~/babdata/quotes >/home/admin/cronlog.log 2>&1
;; 3 11,18,19 * * * /home/admin/bin/masttoot.sh ~/babdata/ellul >/home/admin/cronlog.log 2>&1
;; 11 11,12,13,14,17,18,19,20 * * * /home/admin/bin/tweet.sh ~/babdata/twitter >/home/admin/cronlog.log 2>&1



(let* ((nexthour 2)
       (adder '(1 6 12 18))
       (next4hrs (sort-list (map (lambda (x)(remainder (+ nexthour x) 24))   adder ) <))
       )
  (display next4hrs))


(define (update-mcron-jobs exe dir freq)
  ;;exe: the bash script to use
  ;;dir: the target directory containing envs
  ;;freq on of "hourly" "every-six" or "daily"
  (let* (
	;; (exe "masttoot.sh")
	;; (dir "~/babdata/bernays")
	 (log ">~/mcronlog.log 2>&1")
	;; (freq "hourly")
	 (current-hour  (date-hour (current-date)))
	 (next4hrs (sort-list (map (lambda (x)(remainder (+ current-hour x) 24)) '(1 6 12 18)) <))
	 (job-freq (cond
        	    ((string=? freq "hourly") (format #f "next-minute-from (next-hour) '(~a)" (number->string (random 59))))
        	    ((string=? freq "every-six") (format #f "next-minute-from (next-hour '~a) '(~a)" next4hrs (number->string (random 59))))
        	    ((string=? freq "daily") (format #f "next-hour '(~a)" current-hour))))
	 (entry (format #f "(job '(~a) \"~a ~a ~a\")" job-freq exe dir log ))
	 (port (open-file "~/.config/cron/job.guile" "a")))
    (begin
      (display s port)
      (close-port port))))


;;(job '(next-minute)
     (lambda ()
       (let* ((s (string-append        (number->string  (date-day (current-date))) "\t"
				       (number->string  (date-hour (current-date))) "\t"
				       (number->string  (date-minute (current-date))) "\t"
				       "cd ~/babdata/kazcin && ~/bin/masttoot.sh ~/babdata/kazcin >~/cronlog.log 2>&1" "\n"))
		(port (open-file "/home/mbc/.config/cron/mcron-out.txt" "a"))
				       )
		(begin
		(display s port)
		(close-port port))

))


(job '(next-minute-from (next-hour '(6 7 8)) '(3)) "/home/admin/bin/masttoot.sh /home/admin/babdata/kazcin >/home/admin/mcronlog.log 2>&1")



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


