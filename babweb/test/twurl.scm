#! /home/mbc/.guix-profile/bin/guile \
-e main -s
!#

;;(add-to-load-path "/home/mbc/temp/test")
(add-to-load-path "/home/mbc/projects/babweb")
(add-to-load-path "/home/mbc/projects/babweb/babweb")
(add-to-load-path "/home/mbc/projects/guile-oauth")
(add-to-load-path "/home/mbc/projects/guile-gcrypt")

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
	     (oauth oauth1 request)
	     (rnrs bytevectors)
	     (ice-9 textual-ports)
	     (babweb lib env)
	     (babweb lib image)
	     (babweb lib utilities)
	     (babweb lib twitter)
	    (rnrs bytevectors)
	    (gcrypt hmac)
	    (gcrypt mac)
	    (gcrypt base64)
	    (ice-9 binary-ports)
	     )

(define-record-type <response-token>
  (make-response-token token_type access_token)
  response-token?
  (token_type response-token-type)
  (access_token response-token-access-token))

(define oauth-response-token-record (make-response-token "bearer" *oauth-access-token* ))

(define (signature-request-url uri)
  (string-append (symbol->string (uri-scheme uri))
                 "://"
                 (uri-host uri)
                 (port->string uri)
                 (uri-path uri)))

(define (libgcrypt->procedure return name params)
  "Return a pointer to symbol FUNC in libgcrypt."
  (catch #t
    (lambda ()
      (let ((ptr (dynamic-func name (dynamic-link %libgcrypt))))
        ;; The #:return-errno? facility was introduced in Guile 2.0.12.
        (pointer->procedure return ptr params
                            #:return-errno? #t)))
    (lambda args
      (lambda _
        (throw 'system-error name  "~A" (list (strerror ENOSYS))
               (list ENOSYS))))))




(define (standard-port? uri)
  (or (not (uri-port uri))
      (and (eq? 'http (uri-scheme uri))
           (= 80 (uri-port uri)))
      (and (eq? 'https (uri-scheme uri))
           (= 443 (uri-port uri)))))

(define (port->string uri)
  (if (standard-port? uri)
      ""
      (string-append ":" (number->string (uri-port uri)))))

(define (mac-open algorithm)
  "Create a <mac> object set to use ALGORITHM"
  (let* ((mac (bytevector->pointer (make-bytevector (sizeof '*))))
         (err (%gcry-mac-open mac algorithm 0 %null-pointer)))
    (if (= err 0)
        (pointer->mac (dereference-pointer mac))
        (throw 'gcry-error 'mac-open err))))


(define %gcry-mac-open
  (libgcrypt->procedure int "gcry_mac_open"
                        ;; gcry_mac_hd_t *HD, int ALGO,
                        ;; unsigned int FLAGS, gcry_ctx_t CTX
                        `(* ,int ,unsigned-int *)))

;; Client credentials:

;;     App Key === API Key === Consumer API Key === Consumer Key === Customer Key === oauth_consumer_key
;;     App Key Secret === API Secret Key === Consumer Secret === Consumer Key === Customer Key === oauth_consumer_secret
;;     Callback URL === oauth_callback
     

;; Temporary credentials:

;;     Request Token === oauth_token
;;     Request Token Secret === oauth_token_secret
;;     oauth_verifier
     

;; Token credentials:

;;     Access token === Token === resulting oauth_token
;;     Access token secret === Token Secret === resulting oauth_token_secret


(define (get-request-token k s)
;;(define (get-request-token )
  ;; returns a response: #<<oauth1-response> token: "Ia2k4gAAAAABb11DAAABgJn1fzQ" secret: "Pi8PTBLsyuE7tsfB1X2anChF3WyP1R7e" params: ()>
  ;; retrieve with  token: (oauth1-response-token a)
  ;;                secret: (oauth1-response-token-secret a)
  (let*( (uri "https://api.twitter.com/oauth/request_token")
	 ;;(credentials (make-oauth1-credentials oauth-access-token oauth-token-secret))
	 (credentials (make-oauth1-credentials k s))	 
;;	 (credentials (make-oauth1-credentials *oauth-consumer-key* *oauth-consumer-secret*))	 
	 (a  (oauth1-client-request-token uri credentials "oob"    ;;for pin
;;	 (a  (oauth1-client-request-token uri credentials "http://build-a-bot.biz/twittreg2"
					 #:method 'POST
					 #:params '()
					 #:signature oauth1-signature-hmac-sha1)))	
  a))






(define (hmac-sha1-key client-secret token-secret)
  (string-append (uri-encode client-secret)
                 "&"
                 (uri-encode token-secret)))


(define (hmac-sha1-signature base-string )
  (let ((key (string-append (uri-encode *oauth-consumer-secret*)
                 "&"
                 (uri-encode *oauth-token-secret*))))
    (sign-data-base64 key base-string #:algorithm 'sha1)))

(define aa "oauth_body_hash=BStohwKFnl3EC%2FP1oTSQCCfEDrc%3D, oauth_consumer_key=vDEXcHWNRgg6DmhyOQNY8Dbxv, oauth_nonce=TA2mn7uFaVEuIdE1PRfyVgctXClERjYYrOwH7Q, oauth_signature=Y9pp5%2F1zt2Ta%2FH6sgpLBQlCJbZY%3D, oauth_signature_method=HMAC-SHA1, oauth_timestamp=1724097883, oauth_token=856105513800609792-E1ITWCXTPJ7gtIlupag4NoEFHAdUMFx, oauth_version=1.0")

;;(hmac-sha1-signature aa )


(define (twurl-auth)
  (let* ((command (string-append "twurl -t authorize --consumer-key " *oauth-consumer-key* " --consumer-secret " *oauth-consumer-secret*))
	 )
    (begin
      (pretty-print command)
     ;; (receive (response body)
(pretty-print 	  (system command))
      ;;	(pretty-print (utf8->string body)))
      

      )))

;;  "POST /1.1/media/upload.json?media_category=TWEET_IMAGE HTTP/1.1\r\nAccept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3\r\nAccept: */*\r\nUser-Agent: twurl version: 0.9.7 platform: ruby 3.2.3 (x86_64-linux-gnu)\r\n
;;  Content-Type: multipart/form-data, boundary=\"00Twurl819416368259160374lruwT99\"\r\n
;; Authorization: OAuth oauth_body_hash=\"BStohwKFnl3EC%2FP1oTSQCCfEDrc%3D\",
;;  oauth_consumer_key=\"vDEXcHWNRgg6DmhyOQNY8Dbxv\", oauth_nonce=\"TA2mn7uFaVEuIdE1PRfyVgctXClERjYYrOwH7Q\",
;; oauth_signature=\"Y9pp5%2F1zt2Ta%2FH6sgpLBQlCJbZY%3D\",
;;  oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\"1724097883\", oauth_token=\"856105513800609792-E1ITWCXTPJ7gtIlupag4NoEFHAdUMFx\",
;; oauth_version=\"1.0\"\r\n
;;  Connection: close\r\nHost: upload.twitter.com\r\nContent-Length: 329241\r\n\r\n"
;; <- "--00Twurl819416368259160374lruwT99\r\nContent-Disposition: form-data; name=\"media\"; filename=\"scope.jpeg\"\r\n
;; Content-Type: application/octet-stream\r\n\r\n\xFF\xD8\xFF\xE0\x00\x10JFIF\x00\x01\x01\x00\x00H\x00H\x00\x00\xFF\xDB\x00C\x00\x04\x04\x04\x04\x04\x04\a\x04\x04\a\n\a\a\a\n\r\n\n\n\n\r\x10\r\r\r\r\r\x10\x14\x10\x10\x10\x10\x10\x10\x14\x14\x14\x14\x14\x14\x14\x14\x18\x18\x18\x18\x18\x18\x1C\x1C\x1C\x1C\x1C\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\xFF\xDB\x00C\x01\x05\x05\x05\b\a\b\x0E\a\a\x0E \x16\x12\x16                                                  \xFF\xC2\x00\x11\b\x03\x80\x05@\x03\x01\"\x00\x02\x11\x01\x03\x11\x01\xFF\xC4\x00\x1C\x00\x00\x03\x01\x01\x01\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x01\x02\x03\x00\x04\x05\x06\a\b\xFF\xC4\x00\x1A\x01\x01\x


(define (test-oauth1-simple-image-upload )
  ;;https://developer.x.com/en/docs/twitter-api/v1/media/upload-media/api-reference/post-media-upload
  ;;https://developer.twitter.com/en/docs/authentication/oauth-1-0a/authorizing-a-request
  ;;https://developer.twitter.com/en/docs/authentication/oauth-1-0a/creating-a-signature
  (let* (
	 (oauth1-response (make-oauth1-response *oauth-access-token* *oauth-token-secret* '(("user_id" . "856105513800609792") ("screen_name" . "mbcladwell")))) ;;these credentials do not change	
	 (credentials (make-oauth1-credentials *oauth-consumer-key* *oauth-consumer-secret*))
	 (uri  "https://upload.twitter.com/1.1/media/upload.json?media_category=TWEET_IMAGE")
	 (image-request (make-oauth-request uri 'POST '()))
	 (file-name "/home/mbc/Pictures/scope.jpeg")
	 (size-in-bytes (number->string (stat:size (stat file-name))))
	 (p (open-input-file file-name))
 	 (bytes (get-bytevector-all p))	 
 	 (bytes64 (base64-encode bytes))
 	 (dummy (close-port p))
	 (body-hash (hmac-sha1-signature bytes64 ))
	;; (data "@/home/mbc/Pictures/scope.jpeg")
	;; (data "/home/mbc/Pictures/scope.jpeg")
	;; (data (string-append "{\"media\" : " bytes64 "}"))
	 (data (string-append "media=" bytes64))
	 
;;	 (data "{\"media\":@/home/mbc/Pictures/scope.jpeg}")
	 (dummy (oauth-request-add-params image-request `( 
	  						   (oauth_consumer_key . ,*oauth-consumer-key*)
							   (oauth_nonce . ,(oauth1-nonce))
							   (oauth_timestamp . ,(oauth1-timestamp))
							   (oauth_token . ,*oauth-access-token*)
							   (oauth_body_hash . ,body-hash)
							  ;; (total_bytes . ,size-in-bytes)
							  ;; (Content-Type . "application/x-www-form-urlencoded")
							  ;; (Content-Type . "application/json")
							  ;; (Content-Type . "multipart/form-data")
							  ;; (Content-Type . "application/octet-stream")
							   (oauth_version . "1.0")
							 ;; (media_category . "TWEET_IMAGE")
							 ;;  (media_type . "image/jpeg")
							;;  (media . "/home/mbc/Pictures/scope.jpeg")
							 ;; (media . ,data)
							   ;;(status . ,text)
							   ) ))
	;; (dummy (if (string=? reply-id "") #f (oauth-request-add-param image-request 'in_reply_to_status_id reply-id) ))
	;; (dummy (if (string=? media-id "") #f (oauth-request-add-param image-request 'media_ids media-id) ))
	 (dummy (oauth1-request-sign image-request credentials oauth1-response #:signature oauth1-signature-hmac-sha1))
	 (_ (pretty-print "====step3========="))
	 (_ (pretty-print image-request))
	 )
;;    #f
    (oauth1-http-request image-request #:params-location 'header #:body data #:extra-headers `((Content-Type . "multipart/form-data")) #:http-proc http-request)
    ))

(define (test-curl-concat)
  (let* (
       ;;(oauth1-response (make-oauth1-response *oauth-access-token* *oauth-token-secret* '(("user_id" . "856105513800609792") ("screen_name" . "mbcladwell")))) ;;these credentials do not change
	 
       (oauth1-response (make-oauth1-response *oauth-access-token* *oauth-token-secret* '(("user_id" . "1516431938848006149") ("screen_name" . "eddiebbot"))))

	 (credentials (make-oauth1-credentials *oauth-consumer-key* *oauth-consumer-secret*))
 	 (uri  "https://upload.twitter.com/1.1/media/upload.json?media_category=TWEET_IMAGE")
	 (image-request (make-oauth-request uri 'POST '()))
	 (file-name "/home/mbc/Pictures/scope.jpeg")
	 (size-in-bytes (number->string (stat:size (stat file-name))))
	 (p (open-input-file file-name))
 	 (bytes (get-bytevector-all p))	 
 	 (bytes64 (base64-encode bytes))
	 (body-hash (hmac-sha1-signature bytes64 ))
	 (nonce1 (oauth1-nonce))
	 (timestamp (oauth1-timestamp))
 	 (dummy (close-port p))
	 (_ (oauth-request-add-params image-request `( 
							  (oauth_consumer_key . ,*oauth-consumer-key*)
							  (oauth_nonce . ,nonce1)
							  ;;(oauth_signature_method . "HMAC-SHA1")
							  (oauth_timestamp . ,timestamp)
							  (oauth_token . ,*oauth-access-token*)
							 ;; (oauth_body_hash . ,body-hash)
							 ;;  (Content-Type . "multipart/form-data")
							  (oauth_version . "1.0")
							 ;; (media . "@/home/mbc/Pictures/scope.jpeg")
							  )))
;;	 pulling from guile-oauth
	(s  (let ((method (oauth-request-method image-request))
		  (uri (string->uri (oauth-request-url image-request)))
		  (params (oauth-request-params image-request)))
	      (string-join
	       (map (lambda (p) (uri-encode p))
		    (list (symbol->string method)
			  (signature-request-url uri)
			  (oauth1-normalized-params params)))
	       "&")))

;;	 (_ (pretty-print s))
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	(_ (oauth1-request-sign image-request credentials oauth1-response #:signature oauth1-signature-hmac-sha1))
	(_ (pretty-print  (oauth-request-params image-request) ))
	 
	(sig (assoc-ref (oauth-request-params image-request) 'oauth_signature))
	 

;;twurl -X POST -H upload.twitter.com "/1.1/media/upload.json?media_category=TWEET_IMAGE&additional_owners=3805104374" -f adsapi-heirarchy.png -F media

;;  "POST /1.1/media/upload.json?media_category=TWEET_IMAGE HTTP/1.1\r\nAccept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3\r\nAccept: */*\r\nUser-Agent: twurl version: 0.9.7 platform: ruby 3.2.3 (x86_64-linux-gnu)\r\n
;;  Content-Type: multipart/form-data, boundary=\"00Twurl819416368259160374lruwT99\"\r\n
;; Authorization: OAuth oauth_body_hash=\"BStohwKFnl3EC%2FP1oTSQCCfEDrc%3D\",
;;  oauth_consumer_key=\"vDEXcHWNRgg6DmhyOQNY8Dbxv\", oauth_nonce=\"TA2mn7uFaVEuIdE1PRfyVgctXClERjYYrOwH7Q\",
;; oauth_signature=\"Y9pp5%2F1zt2Ta%2FH6sgpLBQlCJbZY%3D\",
;;  oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\"1724097883\", oauth_token=\"856105513800609792-E1ITWCXTPJ7gtIlupag4NoEFHAdUMFx\",
;; oauth_version=\"1.0\"\r\n
;;  Connection: close\r\nHost: upload.twitter.com\r\nContent-Length: 329241\r\n\r\n"
;; <- "--00Twurl819416368259160374lruwT99\r\nContent-Disposition: form-data; name=\"media\"; filename=\"scope.jpeg\"\r\n
;; Content-Type: application/octet-stream\r\n\r\n\xFF\xD8\xFF\xE0\x00\x10JFIF\x00\x01\x01\x00\x00H\x00H\x00\x00\xFF\xDB\x00C\x00\x04\x04\x04\x04\x04\x04\a\x04\x04\a\n\a\a\a\n\r\n\n\n\n\r\x10\r\r\r\r\r\x10\x14\x10\x10\x10\x10\x10\x10\x14\x14\x14\x14\x14\x14\x14\x14\x18\x18\x18\x18\x18\x18\x1C\x1C\x1C\x1C\x1C\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\xFF\xDB\x00C\x01\x05\x05\x05\b\a\b\x0E\a\a\x0E \x16\x12\x16                                                  \xFF\xC2\x00\x11\b\x03\x80\x05@\x03\x01\"\x00\x02\x11\x01\x03\x11\x01\xFF\xC4\x00\x1C\x00\x00\x03\x01\x01\x01\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x01\x02\x03\x00\x04\x05\x06\a\b\xFF\xC4\x00\x1A\x01\x01\x
	 
	   (command (string-append "curl -X POST -H 'Authorization: OAuth oauth_consumer_key=" *oauth-consumer-key* ", oauth_nonce=" nonce1 ", oauth_signature=" sig ", oauth_signature_method=HMAC-SHA1, oauth_timestamp=" timestamp ", oauth_token=" *oauth-access-token* ", oauth_version=1.0' -H 'Content-Type: multipart/form-data' --data-binary 'media=/home/mbc/Pictures/scope.jpeg' https://upload.twitter.com/1.1/media/upload.json?media_category=TWEET_IMAGE")
		  
		    ))
    (begin
      ;; (receive (response body)
      (pretty-print 	  (system command))
      ;;	(pretty-print (utf8->string body)))
      (pretty-print command)
      )))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;guix shell -m manifest.scm guile -- ./twurl.scm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (main args)
  (let* ((start-time (current-time time-monotonic))	 
	 (stop-time (current-time time-monotonic))
	 (_  (pretty-print (string-append "in twitt: " *oauth-consumer-key*)))
;;	 (_ (get-access-token))
	 (elapsed-time (ceiling (time-second (time-difference stop-time start-time))))
	 )
    (begin
      (pretty-print (string-append "Shutting down after " (number->string elapsed-time) " seconds of use."))

     ;; (twurl-auth)
      (test-curl-concat)      
       ;; (receive (response body)
       ;; 	   (test-oauth1-simple-image-upload)
       ;; 	(pretty-print (utf8->string body)))      
;;	    (envs-report "envs")      
	;;    (envs-report "oauth1_access_token_envs")      
      ;;
      )))



