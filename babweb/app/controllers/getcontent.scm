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
  #:use-module (ice-9 regex) ;;list-matches
  #:use-module (ice-9 string-fun)  ;;string-replace-substring	   
	   
  #:use-module (ice-9 textual-ports) ;;get-string-all
  )
  
(define-artanis-controller getcontent) ; DO NOT REMOVE THIS LINE!!!




(post "/getcontent"
      #:cookies '(names sid cust-id)
    ;;  #:from-post 'qstr
      #:from-post `(store #:path "babdata" #:sync #t #:simple-ret? #f ) 
 (lambda (rc)
   (let* (;;(file1 "notmod")
	  (custid (:cookies-value rc "custid" ))
	  ;;	  (file-dest (string-append "cust" custid))
	  (blah (:from-post rc 'store))
	  (file-names (extract-file-names blah))
	  (raw-quotes-file (car file-names))
;;	  (randoms (cadr file-names))
;;	  (specifics (caddr file-names))

;;	  (_ (process-downloaded-files custid file-names))
	  ;;(sid (:cookie-ref rc "sid"))
	 )
     (view-render "getcontent" (the-environment))
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

(define (make-last-posted-json d)
  ;;d: the project directory 
  (let* ((p  (open-output-file (string-append d "/last-posted.json")))
	 (a (scm->json-string '(("last-posted-id" . 0))))
	 (dummy (put-string p a)))
    (close-port p)))

(define (update-accts-db )
  (let* (

  	 (item `(("name" . ,name)("email" . ,email)))
	 (p  (open-input-file (string-append working-dir "/accounts.json")))
	 (a  (vector->list (json-string->scm (get-string-all p))))
	 ;(a  (vector->list (json-string->scm "[{\"id\":1,\"custid\":\"\",\"name\":\"dummy1\",\"email\":\"email1\"},{\"id\":0,\"custid\":\"\",\"name\":\"dummy0\",\"email\":\"email0\"}]")))	 
	 (dummy (close-port p))
	 (length-orig (length a))
	 (b  (add-two-lists (list item) a length-orig))
	 (c (scm->json-string (list->vector b)))
	 (p  (open-output-file (string-append working-dir "/accounts.json")))
	 (dummy (put-string p c))
	 (dummy (close-port p))

	 )
    
#f
  ))


(define (get-file-name s)
  ;;expecting <p>Upload succeeded! 11391: kingdomcome.zip bytes!</p>
  (let* ((b (string-contains s "bytes!</p>"))
	 (c (substring s 0 (- b 1)))
	 (d (string-index c #\:)))
(substring c (+ d 2) (string-length c))))

(define (extract-file-names a)
  (let* ((s (string-match "</p>" a ))
	 (file1 (get-file-name (substring a 0 (match:end s))))
	 (rest (substring a  (match:end s)))
	 (s (string-match "</p>" rest ))
	 (file2 (get-file-name (substring rest 0 (match:end s))))
	 (rest (substring rest  (match:end s)))
	 (s (string-match "</p>" rest ))
	 (file3 (get-file-name (substring rest 0 (match:end s))))	 
	 )
     (list file3 file2 file1)))


(define (unzip in out)
  ;;in is the file
  ;;out is destination folder
(system (string-append "unzip " in " -d " out))
  )

(define (process-downloaded-files custid files)
  ;;files is a list '(file1 file2 file3)
  (let* (
	 (working-dir (string-append "./babdata/cust" custid))
	 (_ (mkdir working-dir))
	 (random-dir (mkdir (string-append working-dir "/random")))
	 (specific-dir (mkdir (string-append working-dir"/specific")))
	 (raw-quotes-file (car files))
	 (randoms (cadr files))
	 (specifics (caddr files))
	 ;; (_ (rename-file-at "babdata" raw-quotes-file working-dir raw-quotes-file))
	 ;; (_ (rename-file-at "babdata" randoms working-dir randoms))
	 ;; (_ (rename-file-at "babdata" specifics working-dir specifics))
	  (_ (rename-file (string-append "./babdata/" raw-quotes-file) (string-append working-dir "/" raw-quotes-file)))
	  (_ (rename-file (string-append "./babdata/" randoms) (string-append working-dir "/" randoms)))
	  (_ (rename-file (string-append "./babdata/" specifics) (string-append working-dir "/" specifics)))
	 
	  (all-new-quotes (get-all-new-quotes (string-append working-dir "/" raw-quotes-file)))


	  (_ (unzip (string-append working-dir "/" randoms) (string-append working-dir "/random" )))
	 ;; ;;used when appending
	 ;; ;;(last-id (get-last-id))
	 ;; ;;(start (if (= last-id 0) 0 (+ last-id 1)))  ;;record to start populating
	  (start 0)
	  (new-list (process-quotes all-new-quotes '() start ))
	  (_ (save-quotes-as-json working-dir (list->vector new-list)))
	  (_ (make-last-posted-json working-dir))
	 )
    #f

  ))
