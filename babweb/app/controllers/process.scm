;; Controller welcome definition of babweb
;; Please add your license header here.
;; This file is generated automatically by GNU Artanis.
(define-module (app controllers process)
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
  
(define-artanis-controller process) ; DO NOT REMOVE THIS LINE!!!


(get "/process"
      #:cookies '(names custid sid )
;;      #:from-post 'qstr
  (lambda (rc)
    (let* (
	   
	 )
	  (view-render "process" (the-environment)))
  ))



