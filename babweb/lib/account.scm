(define-module (babweb lib account) 
#:use-module (web client)
  #:use-module (srfi srfi-19) ;; date time
  #:use-module (srfi srfi-1)  ;;list searching; delete-duplicates in list 
  #:use-module (srfi srfi-9)  ;;records
  #:use-module (artanis utils) ;;string->sha-256
 #:use-module  (web response)
 #:use-module  (web request)
 #:use-module  (web uri)
 #:use-module  (ice-9 rdelim)
 #:use-module  (ice-9 i18n)   ;; internationalization
 #:use-module  (ice-9 popen)
 #:use-module  (ice-9 regex) ;;list-matches
 #:use-module  (ice-9 receive)	     
 #:use-module  (ice-9 string-fun)  ;;string-replace-substring
 #:use-module  (ice-9 pretty-print)
 #:use-module  (json)
 #:use-module  (ice-9 textual-ports)
  #:export ( main
 ))


  ;; (define-record-type <member>
  ;;   (make-member oauth-id full-name screen-name photo-url oauth-token oauth-verifier)
  ;;   member?
  ;;   (oauth-id member-oauth-id)
  ;;   (full-name member-full-name)
  ;;   (screen-name member-screen-name)
  ;;   (photo-url member-photo-url)
  ;;   (oauth-token member-oauth-token    set-member-oauth-token!)
  ;;   (oauth-verifier member-oauth-verifier set-member-oauth-verifier!))

 (define-json-mapping <member>
    make-member
    member?
    json->member <=> member->json
    (oauth-id member-oauth-id)
    (full-name member-full-name)
    (screen-name member-screen-name)
    (photo-url member-photo-url)
    (oauth-token member-oauth-token )
    (oauth-verifier member-oauth-verifier ))



(define (save-quotes-as-json x)
(let* ((p  (open-output-file "/home/mbc/projects/ebbot/data/acct1/excerpt-db.json"))
	 (a (scm->json-string x))
	 (dummy (put-string p a)))
  (close-port p)))


(define (make-last-posted-json d)
  ;;d: the project directory 
  (let* ((p  (open-output-file (string-append d "/last-posted.json")))
	 (a (scm->json-string '(("last-posted-id" . 0))))
	 (dummy (put-string p a)))
    (close-port p)))

(define (init-db d)
  (let* ((p  (open-output-file (string-append d "/db.json")))
	 (a (scm->json-string '(("content" . "first test tweet")("image" . "")("id" . 0))))
	 (dummy (put-string p a)))
    (close-port p)))

(define (get-all-accounts)
(let*(	 (p  (open-input-file (string-append *working-dir* "/accounts.json")))
	 (a  (vector->list (json-string->scm (get-string-all p))))
	 ;(a  (vector->list (json-string->scm "[{\"id\":1,\"custid\":\"\",\"name\":\"dummy1\",\"email\":\"email1\"},{\"id\":0,\"custid\":\"\",\"name\":\"dummy0\",\"email\":\"email0\"}]")))	 
	 (dummy (close-port p))
	 )
  a))

(define (add-account new-account)
  (let* (
	 (a  (get-all-accounts))
	 (length-orig (length a))
	 (new-acct-list (json-string->scm (member->json new-account)))
	 (updated-acct (acons "id" (get-next-val-param a "id" 0) new-acct-list))
	 (b  (cons  updated-acct a))
	 (c (scm->json-string (list->vector b)))
	 (_ (pretty-print (string-append "in new-account: " c)))
	 (p  (open-output-file (string-append *working-dir* "/accounts.json")))	 
	 )
    (begin
	  (put-string p c)
	  (close-port p))))

;; ./init-acct.scm /home/mbc/projects/bab/data prj1 prj@email.com
;;guile -L /home/mbc/projects/babweb  -e '(babweb lib account)' -s /home/mbc/projects/babweb/babweb/lib/account.scm args


(define (main args)
  ;; args: '( "working-dir"  name email )
  ;;working dir is /home/mbc/projects/bab/data, the location of accounts.json
  (let* ((start-time (current-time time-monotonic))
	;; (dummy (set! working-dir (cadr args)))
	;; (name (caddr args))
	;; (email (cadddr args))
;	 (cust-id (substring (string->sha-256 (string-append name email)) 0 8))
	 ;; (cust-dir (string-append working-dir "/" name))
	 ;; (dummy (mkdir cust-dir))
	 ;; (dummy (make-last-posted-json cust-dir))
	 ;; (dummy (init-db cust-dir))
	 (item (make-member "3726372637623" "Joe Smith" "jsmith" "https://jshdf.com" "1234" "5678"))
	;; (_ (set! *working-dir* "/home/mbc/projects/babdata"))
	 (dummy (add-account item))
	 (stop-time (current-time time-monotonic))
	 (elapsed-time (ceiling (/ (time-second (time-difference stop-time start-time)) 60)))
	 )
   (pretty-print item)    
   ;; (pretty-print (string-append "Elapsed time: " (number->string  elapsed-time) " minutes." ))
    ))

;;accounts.json:
;;[{"id":1,"custid":"","name":"dummy1","email":"email1"},{"id":0,"custid":"","name":"dummy0","email":"email0"}]
