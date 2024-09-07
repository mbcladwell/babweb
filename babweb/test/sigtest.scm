
;;(add-to-load-path "/home/mbc/temp/test")
(add-to-load-path "/home/mbc/projects/babweb")
(add-to-load-path "/home/mbc/projects/babweb/babweb")
(add-to-load-path "/home/mbc/projects/guile-oauth")

(use-modules (web client)
	     (srfi srfi-19)   ;; date time
	     (srfi srfi-1)  ;;list searching; delete-duplicates in list 
	     (ice-9 pretty-print)
	     (ice-9 regex) ;;list-matches
	     (ice-9 string-fun)  ;;string-replace-substring	   
	     (ice-9 textual-ports)
	     (web client)
	     (srfi srfi-19) ;; date time
	     (srfi srfi-1)  ;;list searching; delete-duplicates in list 
	     (srfi srfi-9)  ;;records
	     (web response)
	     (web request)
	     (oop goops) ;; class-of
	     (web uri)
	     (web client)
	     (web http)
	     (ice-9 rdelim)
	     (ice-9 i18n)   ;; internationalization
	     (ice-9 popen)
	     (ice-9 regex) ;;list-matches
	     (ice-9 receive)	     
	     (ice-9 string-fun)  ;;string-replace-substring
	     (ice-9 pretty-print)
	     (ice-9 readline)
	     (json)
	     (gcrypt base64)
	     (oauth oauth1)
	     (oauth oauth2)
	     (oauth oauth2 request)
	     (oauth oauth2 response)
	     (oauth utils)
	     (oauth request)
	     (oauth oauth1 client)
	     (oauth oauth1 utils)
	     (oauth oauth1 credentials)
	     (oauth oauth1 signature)
	     (rnrs bytevectors)
	     (ice-9 textual-ports)
	     (babweb lib env)
	     (babweb lib image)
	     (babweb lib utilities)
	     (babweb lib twitter)
	    (rnrs bytevectors)
	    (gcrypt hmac)
	    (gcrypt base64)
(ice-9 binary-ports)
	     )


(define-record-type <response-token>
  (make-response-token token_type access_token)
  response-token?
  (token_type response-token-type)
  (access_token response-token-access-token))

(define oauth-response-token-record (make-response-token "bearer" *oauth-access-token* ))

;; (define (signature-request-url uri)
;;   (string-append (symbol->string (uri-scheme uri))
;;                  "://"
;;                  (uri-host uri)
;;                  (port->string uri)
;;                  (uri-path uri)))

;; (define (standard-port? uri)
;;   (or (not (uri-port uri))
;;       (and (eq? 'http (uri-scheme uri))
;;            (= 80 (uri-port uri)))
;;       (and (eq? 'https (uri-scheme uri))
;;            (= 443 (uri-port uri)))))

;; (define (port->string uri)
;;   (if (standard-port? uri)
;;       ""
;;       (string-append ":" (number->string (uri-port uri)))))

;;create a signature https://developer.x.com/en/docs/authentication/oauth-1-0a/creating-a-signature

;;  (_ (pretty-print (string-append " : " )))

;; (let* ((method "POST")
;;        (base-url "https://api.x.com/1.1/statuses/update.json")
;;        (status 	"Hello Ladies + Gentlemen, a signed OAuth request!")
;;        (consumer-secret "kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw")
;;        (token-secret 	"LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE")
;;        (credentials (make-oauth1-credentials consumer-secret token-secret))
;;        (_ (pretty-print (string-append "credentials: ==============================" )))
;;        (_ (pretty-print  credentials))
;;        (include-entities 	"true")
;;        (file-name "/home/mbc/Pictures/scope.jpeg")
;;        (size-in-bytes (number->string (stat:size (stat file-name))))
;;        (p (open-input-file file-name))
;;        (bytes (get-bytevector-all p))	 
;;        (data (base64-encode bytes))
;;        (dummy (close-port p))

;;        ;;every oauth_* parameter needs to be included in the signature,
;;        ;;Percent encode every key and value that will be signed.
;;        ;; Sort the list of parameters alphabetically [1] by encoded key [2].
;;        ;; For each key/value pair:
;;        ;; Append the encoded key to the output string.
;;        ;; Append the ‘=’ character to the output string.
;;        ;; Append the encoded value to the output string.
;;        ;; If there are more key/value pairs remaining, append a ‘&’ character to the output string.
;;        (oauth-consumer-key 	"xvz1evFS4wEEPTGEFPHBog")
;;        (oauth-nonce 	"kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg")
;;        (oauth-signature-method 	"HMAC-SHA1")
;;        (oauth-timestamp 	"1318622958")
;;        (oauth-token 	"370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb")
;;        (oauth-version 	"1.0")
;;        (oauth1-response (make-oauth1-response oauth-token token-secret '(("user_id" . "856105513800609792") ("screen_name" . "mbcladwell"))))
;;        (_ (pretty-print (string-append "oauth1-response : "                )))
;;        (_ (pretty-print  oauth1-response))
;;        (test-request (make-oauth-request base-url 'POST '()))
;;        (_ (pretty-print (string-append "init request : " )))
;;        (_ (pretty-print test-request))
;;        (_ (oauth-request-add-params test-request `(
;; 						    (include_entities . ,include-entities)
;; 							  (oauth_consumer_key . ,oauth-consumer-key)
;; 							  (oauth_nonce . ,oauth-nonce)
;; 							  (oauth_signature_method . "HMAC-SHA1")
;; 							  (oauth_timestamp . ,oauth-timestamp)
;; 							  (oauth_token . ,oauth-token)
;; 							  (oauth_version . "1.0")
;; 							  )))
;;        ;;	 pulling from guile-oauth
;;        (_ (pretty-print (string-append "2 request : =======================================" )))
;;        (_ (pretty-print  test-request))
;; 	;; (s  (let ((method (oauth-request-method test-request))
;; 	;; 	  (uri (string->uri (oauth-request-url test-request)))
;; 	;; 	  (params (oauth-request-params test-request)))
;; 	;;       (string-join
;; 	;;        (map (lambda (p) (uri-encode p))
;; 	;; 	    (list (symbol->string method)
;; 	;; 		  (signature-request-url uri)
;; 	;; 		  (oauth1-normalized-params params)))
;; 	;;        "&")))
;; ;;	 (_ (pretty-print s))
;; 	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 	 (_ (oauth1-request-sign test-request credentials oauth1-response #:signature oauth1-signature-hmac-sha1))
;; 	 (_ (pretty-print (string-append "3 request : ======================================")))
;; 	 (_ (pretty-print  test-request))

;; 	 )
;; ;;	(_ (pretty-print  (oauth-request-params test-request) ))   
;; ;;	 (sig (assoc-ref (oauth-request-params test-request) 'oauth_signature))
;;   (_ (oauth1-http-request test-request
;; 			  #:params-location 'header
;; 			  #:body data
;; 			  #:extra-headers '((Content-Type . "application/x-www-form-urlencoded"))
;; 			  #:http-proc http-request))
;; 	 )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;guix shell guile -- guile -L /home/mbc/temp/tests ./test.scm
;; guile -L /home/mbc/temp/tests ./test.scm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (main)
  (let* ((start-time (current-time time-monotonic))	 
	 (stop-time (current-time time-monotonic))
	 (_  (pretty-print (string-append "in twitt: " *oauth-consumer-key*)))
;;	 (_ (get-access-token))
	 (elapsed-time (ceiling (time-second (time-difference stop-time start-time))))
	 )
    (begin
      (pretty-print (string-append "Shutting down after " (number->string elapsed-time) " seconds of use."))
      
;;	    (envs-report "envs")      
	;;    (envs-report "oauth1_access_token_envs")      
      ;;
;;      (pretty-print (oauth1-upload-media-init "/home/mbc/Pictures/scope.jpeg" ))
;;(pretty-print  (base64-encode (string->utf8 (string-append *client-id* ":" *client-secret*)))) 
;;      (pretty-print (utf8->string #vu8(123 34 101 114 114 111 114 34 58 34 105 110 118 97 108 105 100 95 114 101 113 117 101 115 116 34 44 34 101 114 114 111 114 95 100 101 115 99 114 105 112 116 105 111 110 34 58 34 77 105 115 115 105 110 103 32 114 101 113 117 105 114 101 100 32 112 97 114 97 109 101 116 101 114 32 91 99 111 100 101 95 118 101 114 105 102 105 101 114 93 46 34 125)))
      )))

(main)

