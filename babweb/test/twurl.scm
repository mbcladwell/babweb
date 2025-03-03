
(add-to-load-path "/home/mbc/projects/babweb")

(use-modules (srfi srfi-19)   ;; date time
	     (srfi srfi-1)  ;;list searching; delete-duplicates in list 
	     (srfi srfi-9)  ;;records
	     (web response)(web request) (web uri)(web client) (web http)
	   ;;  (oop goops) ;; class-of	    	     	    
	     (ice-9 pretty-print)
	     (ice-9 regex) ;;list-matches
	     (ice-9 string-fun)  ;;string-replace-substring	   
	     (ice-9 rdelim)
	     (ice-9 i18n)   ;; internationalization
	     (ice-9 popen)
	     (ice-9 receive)	     
	     (ice-9 readline)
	     (ice-9 iconv)
	     (ice-9 textual-ports)(ice-9 binary-ports)
	     (json)
	     (oauth oauth1) (oauth oauth1 client)(oauth oauth1 utils)(oauth oauth1 credentials)(oauth oauth1 signature) (oauth oauth1 request)
	     (oauth oauth2)(oauth oauth2 request)(oauth oauth2 response)	     	     
	     (oauth utils)(oauth request)	     	    	     	     	     	    
	     (rnrs bytevectors)
	     (ebbot image)(ebbot utilities)(ebbot twitter)(ebbot env)	     
	     (gcrypt hmac)(gcrypt mac)(gcrypt base64)	    
	     (rnrs io ports ) ;;make-transocder
	     )

(define *oauth-consumer-key* #f)
(define *oauth-consumer-secret*  #f)
(define *bearer-token* #f)   ;;this does not change
(define *oauth-access-token* #f) 
(define *oauth-token-secret* #f)
(define *client-id* #f)
(define *client-secret* #f) 
(define *platform* #f)
(define *redirecturi* #f)
(define *data-dir* #f)
(define *tweet-length* #f) 
(define *gpg-key* "babweb@build-a-bot.biz")

(define (set-envs varlst)
  (begin
      (set! *oauth-consumer-key* (assoc-ref varlst "oauth-consumer-key"))
      (set! *oauth-consumer-secret* (assoc-ref varlst "oauth-consumer-secret"))
      (set! *bearer-token* (assoc-ref varlst "bearer-token"))
      (set! *oauth-access-token* (assoc-ref varlst "oauth-access-token"))
      (set! *oauth-token-secret* (assoc-ref varlst "oauth-token-secret"))
      (set! *client-id* (assoc-ref varlst "client-id"))
      (set! *client-secret* (assoc-ref varlst "client-secret"))
      (set! *redirecturi* (assoc-ref varlst "redirecturi"))
      (set! *platform* (assoc-ref varlst "platform"))
;;      (set! *data-dir* (assoc-ref varlst "data-dir"))
      (set! *tweet-length* (if (assoc-ref varlst "tweet-length")			    
			       (string->number (assoc-ref varlst "tweet-length"))
			       #f))))


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

;; (define (mac-open algorithm)
;;   "Create a <mac> object set to use ALGORITHM"
;;   (let* ((mac (bytevector->pointer (make-bytevector (sizeof '*))))
;;          (err (%gcry-mac-open mac algorithm 0 %null-pointer)))
;;     (if (= err 0)
;;         (pointer->mac (dereference-pointer mac))
;;         (throw 'gcry-error 'mac-open err))))


;; (define %gcry-mac-open
;;   (libgcrypt->procedure int "gcry_mac_open"
;;                          gcry_mac_hd_t *HD, int ALGO,
;;                          unsigned int FLAGS, gcry_ctx_t CTX
;;                         `(* ,int ,unsigned-int *)))

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
;   ;https://developer.x.com/en/docs/twitter-api/v1/media/upload-media/api-reference/post-media-upload
  ;;https://developer.twitter.com/en/docs/authentication/oauth-1-0a/authorizing-a-request
  ;;https://developer.twitter.com/en/docs/authentication/oauth-1-0a/creating-a-signature
  ;;https://devcommunity.x.com/t/image-upload-gets-could-not-authenticate-you-error-free-tier/223066
  (let* (
	 (oauth1-response (make-oauth1-response *oauth-access-token* *oauth-token-secret* '(("user_id" . "856105513800609792") ("screen_name" . "mbcladwell")))) ;;these credentials do not change	
;;	 (oauth1-response (make-oauth1-response *oauth-access-token* *oauth-token-secret* '(("user_id" . "1516431938848006149") ("screen_name" . "eddiebbot")))) ;;these credentials do not change	
	 (credentials (make-oauth1-credentials *oauth-consumer-key* *oauth-consumer-secret*))
	 (uri  "https://upload.twitter.com/1.1/media/upload.json?media_category=TWEET_IMAGE")
;;	 (uri  "https://upload.twitter.com/1.1/media/upload.json")
	 (image-request (make-oauth-request uri 'POST '()))
	 (image-path "/home/mbc/Pictures/scope.jpeg")
	 (size-in-bytes (number->string (stat:size (stat image-path))))
         (image-data (call-with-input-file image-path get-bytevector-all))
	 (image-filename (basename image-path))
;;	 (data  (base64-encode image-data))
	 (data  (string-append "media_data=" (base64-encode image-data)))
	 (body-hash (hmac-sha1-signature data))
	 (_ (oauth-request-add-params image-request `( 
	  						   (oauth_consumer_key . ,*oauth-consumer-key*)
							   (oauth_nonce . ,(oauth1-nonce))
							   (oauth_timestamp . ,(oauth1-timestamp))
							   (oauth_token . ,*oauth-access-token*)
							   (oauth_version . "1.0")
							   (oauth_body_hash . ,body-hash)
							  ;; (Content-Type . "multipart/form-data")
							 ;;  (Content-Length . ,size-in-bytes)
							 ;;  (filename . ,image-filename)
							   )))
	;; (dummy (if (string=? reply-id "") #f (oauth-request-add-param image-request 'in_reply_to_status_id reply-id) ))
	;; (dummy (if (string=? media-id "") #f (oauth-request-add-param image-request 'media_ids media-id) ))
	 (dummy (oauth1-request-sign image-request credentials oauth1-response #:signature oauth1-signature-hmac-sha1))
	 (_ (pretty-print "====step3========="))
	 (_ (pretty-print image-request))
	 (_ (pretty-print "=================="))
	 )
;;    #f
   (receive (response body)
   (oauth1-http-request image-request
			 #:params-location 'header
			 #:body data
			 #:extra-headers `(
					   (Content-Type . "multipart/form-data")
	;;				   (Content-Length . ,size-in-bytes)
;;					   (filename . ,image-filename)
					   
	 				   )
			 #:http-proc http-request)
    (json-string->scm (utf8->string body)))
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

(define (twurl-get-id pic-file-name)
  (let* ((command (string-append "twurl -t -X POST -H upload.twitter.com /1.1/media/upload.json?media_category=TWEET_IMAGE -f " pic-file-name " -F media"))
	 (js (call-command-with-output-to-string command))
	 (lst  (json-string->scm js)))
     (assoc-ref lst "media_id_string")))

(define (oauth1-upload-media-init  file-name)
  ;;Requires authentication? 	Yes (user context only)
  ;;https://developer.twitter.com/en/docs/authentication/oauth-1-0a/authorizing-a-request
  ;;https://developer.twitter.com/en/docs/authentication/oauth-1-0a/creating-a-signature
  ;;twurl -t -H upload.twitter.com "/1.1/media/upload.json" -d "command=INIT&media_type=image/jpg&total_bytes=42572"

;;   <- "POST /1.1/media/upload.json HTTP/1.1\r\nAccept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3\r\nAccept: */*\r\nUser-Agent: twurl version: 0.9.7 platform: ruby 3.2.3 (x86_64-linux-gnu)\r\nContent-Type: application/x-www-form-urlencoded\r\nAuthorization: OAuth oauth_consumer_key=\"vDEXcHWNRgg6DmhyOQNY8Dbxv\", oauth_nonce=\"HdmnvJEThtMAW6SlOPyw0CimxLI29zzaEHcHZPSHr8\", oauth_signature=\"EbBHL14%2FijelNc%2BNqvJYQ7Lj0k8%3D\", oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\"1729850449\", oauth_token=\"1516431938848006149-cABE5yQGnISlePpeMQKGsRA6sx1PBq\", oauth_version=\"1.0\"\r\nConnection: close\r\nHost: upload.twitter.com\r\nContent-Length: 53\r\n\r\n"
;; <- "command=INIT&media_type=image%2Fjpg&total_bytes=42572"
;; -> "HTTP/1.1 202 Accepted\r\n"

  (let* (
	 (size-in-bytes (number->string (stat:size (stat file-name))))
	 (oauth1-response (make-oauth1-response *oauth-access-token* *oauth-token-secret* '(("user_id" . "1516431938848006149") ("screen_name" . "eddiebbot")))) ;;these credentials do not change
;;	 (_ (pretty-print size-in-bytes))
	 (dummy (pretty-print (string-append "*oauth-access-token*: " *oauth-access-token*)))
	 (suffix (cadr (string-split file-name #\.)))
	 (media-type (string-append "image/" suffix))
	 (credentials (make-oauth1-credentials *oauth-consumer-key* *oauth-consumer-secret*))
 	 (uri  "https://upload.twitter.com/1.1/media/upload.json")
;;	 (uri  "https://upload.twitter.com/1.1/media/upload.json?media_category=TWEET_IMAGE"  )
	 (_ (pretty-print uri))
	;; (data  (string-append "command=INIT&media_type=" media-type "&total_bytes=" size-in-bytes))
	 (data  "command=INIT&media_type=image%2Fjpg&total_bytes=42572")
	;; (data  "media_category=TWEET_IMAGE&command=INIT&media_type=image%2Fjpg&total_bytes=42572")
	 (_ (pretty-print data))
	 
	 (_ (pretty-print "==============================================="))
	 (tweet-request (make-oauth-request uri 'POST '()))
	 (dummy (oauth-request-add-params tweet-request `( 
	  						   (oauth_consumer_key . ,*oauth-consumer-key*)
							   (oauth_nonce . ,(oauth1-nonce))
							   (oauth_timestamp . ,(oauth1-timestamp))
							   (oauth_token . ,*oauth-access-token*)
							   (oauth_version . "1.0")
							  ;;  (command . "INIT")
							 ;; (total_bytes . ,size-in-bytes)
							;;  (media_type . ,media-type)						 
							   ;;  (media_category . "TWEET_IMAGE")
;;							  (Content-Type . "application/x-www-form-urlencoded")	
;;							  (Content-Type . "application/octet-stream")	
							  (Content-Type . "multipart/form-data")	
							   
							   )))
	 (dummy (oauth1-request-sign tweet-request credentials oauth1-response #:signature oauth1-signature-hmac-sha1))
	 (_ (pretty-print (oauth-request-params tweet-request)))
	 (_ (pretty-print "================================================"))
	 )
    (receive (response body)
	;; (http-request uri 
	;; 	      #:method 'POST
	;; 	  ;;    #:headers `((content-type . (application/json))					     
	;; 	;;		  (authorization . ,(parse-header 'authorization bearer)))
	;; 	      #:headers (oauth-request-params tweet-request)
	;; 	      #:body data
	;; 	      )



	(oauth1-http-request tweet-request
			  #:params-location 'header
			 #:body data
			 #:extra-headers `(
					   ;; (media_category . "TWEET_IMAGE")
					   ;; (command . "INIT")
					   ;; (total_bytes . ,size-in-bytes)
					   ;; (media_type . ,media-type)						 
					   ;; (Content-Type . "multipart/form-data")
					  ;; (Content-Type . "application/x-www-form-urlencoded")
	 				   )
			 #:http-proc http-request
			 )

;;	  (oauth2-http-request tweet-request #:body #f )
	   (json-string->scm (utf8->string body)))) )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;guix shell -m manifest.scm -- guile -l "twurl.scm" -c '(main "/home/mbc/projects/babweb/babweb/test")'

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (main args)
  (let* ((start-time (current-time time-monotonic))
	 
	 (_ (set-envs (get-envs  args)))
	 (file-name "/home/mbc/Pictures/scope.jpeg")
	 (_  (pretty-print (string-append "in twitt: " *oauth-consumer-key*)))
;;	 (_ (get-access-token))
	 (stop-time (current-time time-monotonic))
	 (elapsed-time (ceiling (time-second (time-difference stop-time start-time))))
	 )
    (begin
      (pretty-print (string-append "Shutting down after " (number->string elapsed-time) " seconds of use."))
      (pretty-print  (twurl-get-id "/home/mbc/Pictures/scope.jpeg"))
;;      (twurl-auth)
;;      (test-curl-concat)      
       ;; (receive (response body)
      ;;       (pretty-print  (test-oauth1-simple-image-upload))
      (pretty-print (oauth1-upload-media-init  file-name))
       ;; 	(pretty-print (utf8->string body)))      
;;	    (envs-report "envs")      
	;;    (envs-report "oauth1_access_token_envs")      
      ;;
      )))



