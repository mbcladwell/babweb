;; Controller welcome definition of babweb
;; Please add your license header here.
;; This file is generated automatically by GNU Artanis.
(define-module (app controllers uploadtweets)
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
  
(define-artanis-controller uploadtweets) ; DO NOT REMOVE THIS LINE!!!


(get "/uploadtweets"
   #:session #t
      #:cookies '(names sid custid)
;;      #:from-post 'qstr
  (lambda (rc)
    (let* (
	   (_  (:cookies-set! rc 'custid "custid" "4567"))
	 )
	  (view-render "uploadtweets" (the-environment)))
  ))

