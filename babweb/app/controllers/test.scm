;; Controller welcome definition of babweb
;; Please add your license header here.
;; This file is generated automatically by GNU Artanis.
(define-module (app controllers test)
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
  )
  
(define-artanis-controller test) ; DO NOT REMOVE THIS LINE!!!


(get "/test"
     #:session 'spawn
      #:cookies '(names custid sid )
;;      #:from-post 'qstr
  (lambda (rc)
    (let* ((myvar (:cookies-value rc "custid"))
	   (sid (:session rc 'spawn))
	   (myvar1 sid)
;;	   (_ (session-set! sid "b" myvar1))
	   
;;	   (_ (:cookies-set! rc 'prjid "anewcokka" "dumdum"))
;;	   (_ (:cookies-remove! rc "anewcokka"))
	   (theenv (the-environment))
	   
	 )
	  (view-render "test" (the-environment)))
    ))




