;; Controller welcome definition of babweb
;; Please add your license header here.
;; This file is generated automatically by GNU Artanis.
(define-module (app controllers getcontent)
  #:use-module (artanis mvc controller)
  #:use-module (artanis utils)
  #:use-module (artanis artanis)
  #:use-module (artanis cookie)
  #:use-module (artanis session)
  #:use-module ((rnrs) #:select (define-record-type))
  #:use-module (artanis irregex)
  #:use-module (srfi srfi-1)
  #:use-module (web uri)	     
  #:use-module (ice-9 pretty-print)
  #:use-module (json)
  #:use-module (ice-9 textual-ports) ;;get-string-all
  )
  
(define-artanis-controller getcontent) ; DO NOT REMOVE THIS LINE!!!




(post "/getcontent"
      #:cookies '(names sid file1)
    ;;  #:from-post 'qstr
      #:from-post '(store #:path "babdata" #:sync #f ) 
 (lambda (rc)
   (let* (;;(file1 "notmod")
	  (custid "123456")
;;	  (_ (process-downloaded-files custid))
	  ;;(sid (:cookie-ref rc "sid"))
	 )
     (redirect-to rc  "getcontent")
     )


   ))


(define db "/db.json")                   ;;the database that provides quotes for tweets and is processed through
(define last-posted "/last-posted.json") ;;last posted id; next tweet is last-posted + 1

  
(define (get-all-new-quotes f)
  (let* ((p  (open-input-file f))
    	 (all-quotes   (string-split  (get-string-all p) #\newline)))    
    all-quotes))


(define (process-quotes old new counter )
  ;; old: original list
  ;; new: '()
  ;; counter: 0
  ;;suffix e.g. "--Edward Bernays, Propaganda (1928)"
  (if (null? (cdr old))
      (begin
	(if (> (string-length (car old)) 2)
	(set! new (cons `(,(cons "content"  (car old)) ("image" . ,(cadr old))  ("id" . ,counter)) new)))
	new)
      (begin
	(if (> (string-length (car old)) 2)
	    (begin
	      (set! new (cons `(,(cons "content" (car old)) ("image" . ,(cadr old))("id" . ,counter)) new))
	      (set! counter (+ 1 counter))))
	(process-quotes (cddr old) new counter ))
      ))


;;this version appends to existing json
;; (define (save-quotes-as-json x)
;; (let* ((p  (open-output-file (string-append working-dir excerpts)))
;; 	 (a (scm->json-string x))
;; 	 (dummy (put-string p a)))
;;   (close-port p)))


(define (save-quotes-as-json working-dir x)
  ;;writes to db.json
(let* ((p  (open-output-file (string-append working-dir "/db.json")))
	 (a (scm->json-string x))
	 (dummy (put-string p a)))
  (close-port p)))

(define (process-downloaded-files custid)
  (let* (
	 (working-dir (string-append "./babdata/cust" custid))
	 (_ (mkdir working-dir))
	 (random-dir (mkdir (string-append working-dir "/random")))
	 (specific-dir (mkdir (string-append working-dir"/specific")))
	 (raw-quotes-file "./babdata/destination.txt" )
	 ;;	  (file1 (:from-post rc 'get-vals "file1"))
	 ;;	   (_ (:cookies-set! rc 'file1 "file1" file1))
					; (counter (get-counter))
	 (all-new-quotes (get-all-new-quotes raw-quotes-file))
	 
	 ;;used when appending
	 ;;(last-id (get-last-id))
	 ;;(start (if (= last-id 0) 0 (+ last-id 1)))  ;;record to start populating
	 (start 0)
	 (new-list (process-quotes all-new-quotes '() start ))
	 (_ (save-quotes-as-json working-dir (list->vector new-list)))
	 )
    #f

  ))
