;; Controller welcome definition of babweb
;; Please add your license header here.
;; This file is generated automatically by GNU Artanis.
(define-module (app controllers getpin)
  #:use-module (artanis mvc controller)
  #:use-module (artanis utils)
  #:use-module (artanis artanis)
  #:use-module (artanis cookie)
  #:use-module ((rnrs) #:select (define-record-type))
  #:use-module (artanis irregex)
  #:use-module (srfi srfi-1)
  #:use-module (web uri)
    #:use-module (babweb lib twitter)
  #:use-module (babweb lib account)
  #:use-module (babweb lib env)
  #:use-module (ice-9 pretty-print)
 #:use-module (oauth oauth1)
 #:use-module (oauth oauth2)
 #:use-module (oauth oauth2 request)
 #:use-module (oauth oauth2 response)
 #:use-module (oauth utils)
 #:use-module (oauth request)
 #:use-module (oauth oauth1 client)
 #:use-module (oauth oauth1 utils)
 #:use-module (oauth oauth1 credentials)
 #:use-module (oauth oauth1 signature)
 #:use-module (babweb lib twitter)

  )
  
(define-artanis-controller getpin) ; DO NOT REMOVE THIS LINE!!!

(post "/getpin"
      #:from-post 'qstr
      #:cookies '(names reqtok acctk accscrt sid)
 (lambda (rc)
		    (let* (
			   (sid (:cookies-value rc "sid"))
			   (request-token (:cookies-value rc "reqtok"))
			   (pin (uri-decode (:from-post rc 'get-vals "pin")))
			  (access-token  (get-access-token request-token pin) )
			  (acc-token (oauth1-response-token access-token))
			   (_ (:cookies-set! rc 'acctk "acctk" acc-token))
			   (acc-secret (oauth1-response-token-secret access-token))
			    (_ (:cookies-set! rc 'accscrt "accscrt" acc-secret))
			 ;; (user-data (get-user-data pin access-token))
			  
			   )
		      (view-render "getpin" (the-environment)))
		    ;;  (view-render "test2" (the-environment)))
		    
		   ))




