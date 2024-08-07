;; Controller welcome definition of babweb
;; Please add your license header here.
;; This file is generated automatically by GNU Artanis.
(define-module (app controllers upload)
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
  
(define-artanis-controller upload) ; DO NOT REMOVE THIS LINE!!!


(get "/upload/tweets"
     #:session #t
     #:cookies '(names sid custid)
  (lambda (rc)
    (let* (
	   (_  (:cookies-set! rc 'custid "custid" "1234"))
	   (_ (DEBUG  (string-append "Value of cwd: " (cwd) )))
	 )
	  (view-render "tweets" (the-environment)))
  ))

(post "/upload/getcontent"
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
	  (blah (:from-post rc 'store))
	  (file-names (extract-file-names blah))
	  (raw-quotes-file (car file-names))
	  (randoms (cadr file-names))
	  (specifics (caddr file-names))
	  (validation-text (get-validation-text file-names))
	  (current-up-path (current-upload-path))
	 ;; (process-message "process messaged shorted")
	  (process-message (process-downloaded-files custid file-names))
	  ;;(process-message "blah")
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


(define (check-a-file f descriptor)
  ;;f the file
  ;;descriptor tweets randoms specifics
  (if (equal? f "null")
      (format #f "<p>File not provided for ~a.</p>" descriptor)
      (format #f "<p>File ~a provided for ~a.</p>" f descriptor)))

(define (get-validation-text file-names)
(let* (
  	 (raw-quotes-file (car file-names))
	 (randoms (cadr file-names))
	 (specifics (caddr file-names))
	 )
  (string-append (check-a-file raw-quotes-file "tweets")
				   (check-a-file randoms "randoms")
				   (check-a-file specifics "specifics"))))

(define (get-file-name s)
  ;;expecting <p>Upload succeeded! kingdomcome.zip: 72834 bytes!</p>
  (let* ((a (string-index s #\:))
	 (b (string-contains s "succeeded! ")))
    (if (= a 21) "null" (substring s (+ b 11) a))))


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
  (system (string-append "unzip " in " -d " out)))


(define process-files-success-message "File Processing completed successfully!")
(define process-files-error-message "Tweets file error - file processing aborted")

(define (process-downloaded-files custid files)
  ;;files is a list '(file1 file2 file3)
  (let* ((cup  (string-replace-substring (current-upload-path) "\"" ""))
	 (working-dir  (string-append cup "/"  custid))
	 (_ (mkdir working-dir))
	 (random-dir (mkdir (string-append working-dir "/random")))
	 (specific-dir (mkdir (string-append working-dir"/specific")))
	 (raw-quotes-file (car files))
	 (randoms (cadr files))
	 (specifics (caddr files))
	 
	 (process-message (if (equal? raw-quotes-file "null")
			      process-files-error-message
			      (let* ((new-quotes-file (string-append working-dir "/" raw-quotes-file))
				     (_ (rename-file (string-append cup "/" raw-quotes-file) new-quotes-file))
				     (all-new-quotes (get-all-new-quotes  new-quotes-file))
				     )
				(begin
				  (save-quotes-as-json working-dir (list->vector (process-quotes all-new-quotes '() 0 )))
				  (make-last-posted-json working-dir)
				  (delete-file new-quotes-file)
				  (if (equal? randoms "null") #f
				      (begin
					(rename-file (string-append cup "/" randoms) (string-append working-dir "/" randoms))
					(unzip (string-append working-dir "/" randoms) (string-append working-dir "/random" ))
					(delete-file (string-append working-dir "/" randoms))))
				  (if (equal? specifics "null") #f
				      (begin
					(rename-file (string-append cup "/" specifics) (string-append working-dir "/" specifics))
					(unzip (string-append working-dir "/" specifics) (string-append working-dir "/specific" ))
					(delete-file (string-append working-dir "/" specifics)))))
			      
				process-files-success-message
				)))
   
	 ;; ;;used when appending
	 ;; ;;(last-id (get-last-id))
	 ;; ;;(start (if (= last-id 0) 0 (+ last-id 1)))  ;;record to start populating
	 )
    process-message
  ))
