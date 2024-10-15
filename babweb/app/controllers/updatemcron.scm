;; Controller welcome definition of babweb
;; Please add your license header here.
;; This file is generated automatically by GNU Artanis.
(define-module (app controllers updatemcron)
  #:use-module (artanis mvc controller)
  #:use-module (artanis utils)
  #:use-module (artanis artanis)
  #:use-module (artanis cookie)
  #:use-module (artanis session)
  #:use-module (artanis upload)
  
  #:use-module ((rnrs) #:select (define-record-type))
  #:use-module (artanis irregex)
  #:use-module (srfi srfi-1)
  #:use-module (web uri)	     
  #:use-module (ice-9 pretty-print)
  #:use-module (json)
  #:use-module (ice-9 textual-ports) ;;get-string-all
  #:use-module (ice-9 format)
  #:use-module (ice-9 regex) ;;list-matches
;;  #:use-module (oop goops) ;;class-of
  #:use-module (ice-9 string-fun)  ;;string-replace-substring	   

  )
  
(define-artanis-controller updatemcron) ; DO NOT REMOVE THIS LINE!!!



(post "/updatemcron"
      #:cookies '(names sid custid)
    ;;  #:from-post 'qstr
      #:from-post `(store #:path ,(current-upload-path)
			  #:sync #t
			  #:simple-ret? #f ) 
 (lambda (rc)
   (let* (;;(file1 "notmod")
	  ;; (custid (:cookies-value rc "custid" ))
	  (custid "6789")
	  ;;	  (file-dest (string-append "cust" custid))
	  (exe (:from-post rc 'exe))
	  (dir (:from-post rc 'dir))
	  (freq (:from-post rc 'freq))
	  (_ (update-mcron-jobs exe dir freq))
	  ;;(process-message "blah")
	  ;;(sid (:cookie-ref rc "sid"))
	 )
     (view-render "getcontent" (the-environment))
     )


   ))


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

