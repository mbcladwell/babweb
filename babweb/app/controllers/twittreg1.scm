;; Controller welcome definition of babweb
;; Please add your license header here.
;; This file is generated automatically by GNU Artanis.
(define-module (app controllers twittreg1)
  #:use-module (artanis mvc controller)
  #:use-module (artanis utils)
  #:use-module (artanis artanis)
  #:use-module (artanis cookie)
  #:use-module ((rnrs) #:select (define-record-type))
  #:use-module (artanis irregex)
  #:use-module (srfi srfi-1)
  #:use-module (web uri)	     
  #:use-module (ice-9 pretty-print)
  #:use-module (babweb lib twitter)
  #:use-module (babweb lib account)
  #:use-module (babweb lib env)
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

  )
  
(define-artanis-controller twittreg1) ; DO NOT REMOVE THIS LINE!!!


(get "/twittreg1"
      #:cookies '(names reqtok sid )
      #:from-post 'qstr
  (lambda (rc)
    (let* (
	   (action (:from-post rc 'get "action"))
	   (request-token (oauth1-response-token (get-request-token *oauth-consumer-key* *oauth-consumer-secret* )))
	   (_ (:cookies-set! rc 'reqtok "reqtok" request-token))
	   (uri (string-append "https://api.twitter.com/oauth/authenticate?oauth_token=" request-token))
	   )
       (view-render "twittreg1" (the-environment)))
;;	  (redirect-to rc  "/twittacceptpin" ))
  ))

   

;;https://api.x.com/oauth/authenticate?oauth_token=UvaijAAAAAABhb0tAAABkFlLYAs
