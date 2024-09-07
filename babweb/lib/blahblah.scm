#!/usr/bin/guile \
-e main -s
!#
(use-modules (ice-9 pretty-print))
 
;; guix shell -m manifest.scm -- guile -L /home/mbc/projects/babweb  -e '(babweb lib blahblah runner-one)' -s /home/mbc/projects/babweb/babweb/lib/blahblah.scm 

;; guix shell -m manifest.scm -- guile -l /home/mbc/projects/babweb/babweb/lib/blahblah.scm -c '(runner-one "HelloWorld")' 

;; guix shell -m manifest.scm -- guile -s /home/mbc/projects/babweb/babweb/lib/blahblah.scm -e runner-one "HelloWorld"


(define (main args)
  (pretty-print (string-append "in runner-one: " (cadr args))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






;; guile -L /home/mbc/projects/babweb  -e '(babweb lib twitter)' -s /home/mbc/projects/babweb/babweb/lib/twitter.scm 
;; (define (main args)
;;   ;;arg1 is consumer_key
;;   ;;arg2 is consumer_secret
;;   ;;arg3 is customer id
;;   (let* (
;; 	 ;; (token (oauth1-response-token (get-request-token (cadr args) (caddr args))))
;; 	 (_  (pretty-print (string-append "in twitt: " *oauth-consumer-key*)))
;; 	 (token (oauth1-response-token (get-request-token *oauth-consumer-key* *oauth-consumer-secret* )))
;; 	  (uri (string-append "https://api.twitter.com/oauth/authenticate?oauth_token=" token))
;; 	   (dummy (pretty-print uri))
;; 	   (dummy (activate-readline))
;; 	   (pin (readline "\nEnter pin: "))
;; 	 ;; (oauth1-response (get-access-token token pin))  ;;user-id and screenname are the customer
;; 	;;  (oauth1-response (get-access-token (cadr args) (caddr args)))  ;;user-id and screenname are the customer
;; 	  ;; (token (oauth1-response-token oauth1-response))
;; 	  ;; (secret (oauth1-response-token-secret oauth1-response))
;; 	  ;; (params (oauth1-response-params oauth1-response))
;; 	  ;; (a (car params))
;; 	  ;; (b (cadr params))
;; 	  ;; (lst `((token . ,token)(secret . ,secret) ,a ,b))
;; 	  ;; (p  (open-output-file  (string-append "./tokens/" (cadddr args) ".json")))
;; 	  )
    
;; ;;         (scm->json lst p)
	  
    
;;     (pretty-print oauth1-response)
;;     ) )

