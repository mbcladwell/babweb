;; Controller welcome definition of babweb
;; Please add your license header here.
;; This file is generated automatically by GNU Artanis.
(define-module (app controllers tweets)
  #:use-module (artanis mvc controller)
  #:use-module (artanis utils)
  #:use-module (artanis artanis)
  #:use-module (artanis cookie)
  #:use-module ((rnrs) #:select (define-record-type))
  #:use-module (artanis irregex)
  #:use-module (srfi srfi-1)
  #:use-module (web uri)	     
  #:use-module (ice-9 pretty-print)
  )
  
(define-artanis-controller tweets) ; DO NOT REMOVE THIS LINE!!!


(get "/tweets"
;;      #:cookies '(names prjid sid )
;;      #:from-post 'qstr
  (lambda (rc)
    (let* (
	   
	 )
	  (view-render "tweets" (the-environment)))
  ))



