(add-to-load-path "/home/mbc/projects/babweb")
(add-to-load-path "/home/mbc/projects/babweb/babweb")
(add-to-load-path "/home/mbc/projects/guile-oauth")


(use-modules (ice-9 pretty-print)
	     (ice-9 binary-ports)
	     (json)
	     (gcrypt base64)(gcrypt hmac)
	     (oauth oauth1)(oauth oauth1 client) (oauth oauth1 utils) (oauth oauth1 credentials) (oauth oauth1 signature)
	     (oauth oauth2)(oauth oauth2 request)(oauth oauth2 response)	     	     
	      (oauth utils)(oauth request)
	    ;; (oauth)
	     (rnrs bytevectors)
	     (babweb lib env)(babweb lib image) (babweb lib utilities)
	     
	     (babweb lib twitter)
	     (web client) (web response)(web request) (web uri)(web http)
	     (srfi srfi-19) ;; date time
	     (srfi srfi-1)  ;;list searching; delete-duplicates in list 
	     (srfi srfi-9)  ;;records
	     (rnrs io ports ) ;;make-transocder
	     (ice-9 rdelim)
	     (ice-9 i18n)   ;; internationalization
	     (ice-9 popen)
	     (ice-9 regex) ;;list-matches
	     (ice-9 receive)	     
	     (ice-9 string-fun)  ;;string-replace-substring
	     (ice-9 pretty-print)
	     (ice-9 textual-ports)
	       (ice-9 binary-ports)
;;             (ice-9 iconv)
;;	     
	     )

;;#!/home/mbc/.guix-profile/bin/guile -e main -s
;;!#

(define (hmac-sha1-signature base-string )
  (let ((key (string-append (uri-encode *oauth-consumer-secret*)
                 "&"
                 (uri-encode *oauth-token-secret*))))
    (sign-data-base64 key base-string #:algorithm 'sha1)))


;; (define (oauth2-post-tweet-recurse lst reply-id media-id data-dir hashtags counter)
;;   ;;list of tweets to post
;;   ;;reply-id initially #f
;;   ;;counter initially 0; counter is needed to identify reply-id in first round and use media-id if exists
;;   (if (null? (cdr lst))
;;       (begin
;; 	(pretty-print (string-append "cdr lst is null i.e. the last tweet " ))
;; 	(pretty-print (string-append "hashtags: " hashtags))
;; 	(oauth2-post-tweet (string-append (car lst) " " hashtags) #f reply-id data-dir ))
      
;;       (if (eqv? counter 0)
;; 	  (let* ((_ (pretty-print (string-append "counter is 0 i.e. the first tweet " )))
;; 		 (body (receive (response body)	  
;; 			   (oauth2-post-tweet (car lst) media-id reply-id data-dir)
;; 			 body))
;; 		 (_  (set! counter (+ counter 1)))
;; 		 ;; (_ (pretty-print (cdr lst)))
;; 		 ;; (_ (pretty-print  (utf8->string body)))
;; 		 ;; (_ (pretty-print (assoc-ref  (json-string->scm (utf8->string body)) "id_str")))
;; 		 ;; (_ (pretty-print media-id))
;; 		 ;; (_ (pretty-print counter)))
;; 	    (oauth2-post-tweet-recurse  (cdr lst) (assoc-ref  (json-string->scm (utf8->string body)) "id_str")  media-id data-dir hashtags counter)))
;; 	  (begin
;; 	    (pretty-print (string-append "counter is > 0 i.e. tweet 2 or more " ))
;; 	    (receive (response body)	  
;; 		(oauth2-post-tweet (car lst) #f reply-id data-dir )
;; 	      (set! counter (+ counter 1))
;; 	   ;; (pretty-print (string-append "body: " (utf8->string body)))
;; 	   ;; (pretty-print (string-append "response: "))
;; 	;;      (pretty-print response)
;; 	     (oauth2-post-tweet-recurse  (cdr lst) (assoc-ref  (json-string->scm (utf8->string body)) "id_str")  #f data-dir hashtags counter))))))




;;  /home/mbc/.guix-profile/bin/guile -L . -L /home/mbc/projects/guile-oauth -L /home/mbc/projects/babweb -e main ./run.scm /home/mbc/projects/babdata/bernays
;;in data dir 
;;  /home/mbc/.guix-profile/bin/guile -L . -L /home/mbc/projects/guile-oauth -L /home/mbc/projects/babweb -e main /home/mbc/projects/babweb/babweb/test/run.scm
;; for picture
;;  /home/mbc/.guix-profile/bin/guile -L . -L /home/mbc/projects/guile-oauth -L /home/mbc/projects/babweb -e main ./run.scm /home/mbc/Pictures/scope.jpeg
;; for arei
;;  /home/mbc/.guix-profile/bin/guile -L . -m manifest.scm -e main ./run.scm /home/mbc/Pictures/scope.jpeg

  
;; (define (upload-image-to-twitter image-path)
;;   (let* ((url "https://upload.twitter.com/1.1/media/upload.json")
;;          (boundary (string-append "------------------------" (number->string (current-time))))
;;          (image-data (call-with-input-file image-path get-bytevector-all))
;;          (image-filename (basename image-path))
;; 	 (timestamp (date->string (current-date) "~s"))
;;          (nonce (number->string (random 100000000)))
;;          (oauth-params `((oauth_consumer_key . ,*oauth-consumer-key*)
;; 			 (oauth_nonce . ,nonce)
;; 			 (oauth_signature_method . "HMAC-SHA1")
;; 			 (oauth_timestamp . ,timestamp)
;; 			 (oauth_token . ,*oauth-access-token*)
;; 			 (oauth_version . "1.0")))


;; 	 (request-params `(("media" . ,image-filename)))
;; 	 (method "POST")
;; 	 (base-string (signature-base-string method url (append oauth-params request-params)))
;;          (signing-key (string-append (uri-encode *oauth-consumer-secret*) "&" (uri-encode *oauth-token-secret*)))
;;          (signature (hmac-sha1 signing-key base-string))
;;          (oauth-header (string-append
;; 			"OAuth "
;; 			(string-join
;; 			 (map (lambda (param)
;; 				(string-append (uri-encode (symbol->string (car param)))
;; 					       "=\"" (uri-encode (cdr param)) "\""))
;; 			      (append oauth-params `((oauth_signature . ,signature))))
;; 			 ", ")))
;;          (headers `((Authorization . ,oauth-header)
;;                     (Content-Type . ,(string-append "multipart/form-data; boundary=" boundary))))
;;          (body (string-append
;;                 "--" boundary "\r\n"
;;                 "Content-Disposition: form-data; name=\"media\"; filename=\"" image-filename "\"\r\n"
;;                 "Content-Type: application/octet-stream\r\n\r\n"
;;                 (bytevector->string image-data (make-transcoder (latin1-codec)))
;;                 "\r\n--" boundary "--\r\n"))
;; 	 (response (http-post url #:headers headers #:body body))
;; 	 (json-response (json-string->scm (bytevector->string (response-body response) (make-transcoder (utf8-codec))))))
;;       (assoc-ref json-response "media_id_string")))



;; (define (upload-image-to-twitter image-path)
;;   (let* ((url "https://upload.twitter.com/1.1/media/upload.json")
;;          (boundary (string-append "------------------------" (number->string (current-time))))
;;          (image-data (call-with-input-file image-path get-bytevector-all))
;;          (image-filename (basename image-path))
;;          (oauth (make-oauth1-credentials *oauth-consumer-key* *oauth-consumer-secret*))
                 
;;          (request (oauth-request
;;                    #:method 'POST
;;                    #:uri (string->uri url)
;;                    #:oauth oauth))
;;          (signed-request (oauth1-sign-request request '()))
;;          (oauth-header (oauth1-auth-header signed-request))
;;          (headers `((Authorization . ,oauth-header)
;;                     (Content-Type . ,(string-append "multipart/form-data; boundary=" boundary))))
;;          (body (string-append
;;                 "--" boundary "\r\n"
;;                 "Content-Disposition: form-data; name=\"media\"; filename=\"" image-filename "\"\r\n"
;;                 "Content-Type: application/octet-stream\r\n\r\n"
;;                 (bytevector->string image-data (make-transcoder (latin1-codec)))
;;                 "\r\n--" boundary "--\r\n")))
;;     (let* ((response (http-post url #:headers headers #:body body))
;;            (json-response (json-string->scm (bytevector->string (response-body response) (make-transcoder (utf8-codec))))))
;;       (assoc-ref json-response "media_id_string"))))



;;  /home/mbc/.guix-profile/bin/guile -L . -m manifest.scm -e main ./run.scm /home/mbc/Pictures/scope.jpeg
(define (oauth1-upload-media-once  image-path)
  ;;Requires authentication? 	Yes (user context only)
  ;;https://developer.twitter.com/en/docs/authentication/oauth-1-0a/authorizing-a-request
  ;;https://developer.twitter.com/en/docs/authentication/oauth-1-0a/creating-a-signature
  (let* (
	 (size-in-bytes (number->string (stat:size (stat image-path)))) ;;329241 from twurl
;;	 (oauth1-response (make-oauth1-response *oauth-access-token* *oauth-token-secret* '(("user_id" . "1516431938848006149") ("screen_name" . "eddiebbot")))) ;;these credentials do not change
	 (oauth1-response (make-oauth1-response *oauth-access-token* *oauth-token-secret* '(("user_id" . "856105513800609792") ("screen_name" . "mbcladwell")))) ;;these credentials do not change
	;; (_ (pretty-print size-in-bytes))
	 (dummy (pretty-print (string-append "*oauth-access-token*: " *oauth-access-token*)))
	 (suffix (cadr (string-split image-path #\.)))
	 (media-type (string-append "image/" suffix))
	 (boundary (string-append "------------------------" (number->string (time-second (current-time)))))
         (image-data (call-with-input-file image-path get-bytevector-all))
         (image-filename (basename image-path))
	 (body (string-append
                "--" boundary "\r\n"
                "Content-Disposition: form-data; name=\"media\"; filename=\"" image-filename "\"\r\n"
                "Content-Type: application/octet-stream\r\n\r\n"
               (bytevector->string image-data (make-transcoder (utf-8-codec)))
              ;;  (base64-encode image-data)
                "\r\n--" boundary "--\r\n"))
	 (body-hash (hmac-sha1-signature body ))
	 (credentials (make-oauth1-credentials *oauth-consumer-key* *oauth-consumer-secret*))
;; 	 (uri  "https://upload.twitter.com/1.1/media/upload.json")
	 (uri  "https://upload.twitter.com/1.1/media/upload.json?media_category=TWEET_IMAGE")
	 (tweet-request (make-oauth-request uri 'POST '()))
	 (dummy (oauth-request-add-params tweet-request `( 
	  						   (oauth_consumer_key . ,*oauth-consumer-key*)
							   (oauth_nonce . ,(oauth1-nonce))
							   (oauth_timestamp . ,(oauth1-timestamp))
							   (oauth_token . ,*oauth-access-token*)
							   (oauth_version . "1.0")
							   (content-type . ,(string-append "multipart/form-data, boundary=" boundary))
							   (oauth_body_hash . ,body-hash)
									 
						;;	  (total_bytes . ,size-in-bytes)
						;;	  (media_type . ,media-type)						 
						;;	  (media_category . "TWEET_IMAGE")						 
							   )))
	 (dummy (oauth1-request-sign tweet-request credentials oauth1-response #:signature oauth1-signature-hmac-sha1))
	;; (extra-headers '(content-type . "multipart/form-data"))
	 )
    (pretty-print   (receive (response body)	       
	  (oauth1-http-request tweet-request #:body body )
	   (json-string->scm (utf8->string body)))) ))
;;	 (assoc-ref  (json-string->scm (utf8->string body)) "media_id_string")) ))




;; (define (main)
;;   (oauth1-upload-media-once "/home/mbc/Pictures/scope.jpeg" ))
  
;;  (oauth1-upload-media-once "/home/mbc/Pictures/scope.jpeg" ))
;; ( twurlt-get-media-id "/home/mbc/Pictures/scope.jpeg" ))


(define (main )
  (let* ((start-time (current-time time-monotonic))
	 ;; (_ (pretty-print (cadr args)))
;;	 (_ (set! *data-dir* (cadr args)))
	 (_ (pretty-print (string-append "*data-dir*: " *data-dir*)))
	 (counter (get-counter))  ;;note this is the tweet counter
	 (all-excerpts (get-all-excerpts-alist))
	 (max-id (assoc-ref (car all-excerpts) "id"))
	 (new-counter (if (= counter max-id) 0 (+ counter 1)))
	 (entity (find-by-id all-excerpts new-counter))	 
	 (tweets (chunk-a-tweet (assoc-ref entity "content") *tweet-length*))
	 (_ (pretty-print (string-append "tweets: " )))
	 (_ (pretty-print tweets))
	 (hashtags (get-all-hashtags-string))
	  (media-directive (assoc-ref entity "image"))
	  (image-file (if (string=? media-directive "none") #f (get-image-file-name media-directive)))
	  (media-id (if image-file (twurl-get-media-id image-file) #f))
	 (_ (pretty-print (string-append "media-id: " media-id)))
	  (_ (set-counter new-counter))
	 (stop-time (current-time time-monotonic))
	 (elapsed-time (ceiling (time-second (time-difference stop-time start-time))))
	 )
    (begin
      (oauth2-post-tweet-recurse tweets #f media-id *data-dir* hashtags 0)
      (pretty-print (string-append "Shutting down after " (number->string elapsed-time) " seconds of use."))
      ;;provide clickable url to get pin and authorization code; redirects to oauth2step2, writes access code
;;      (twitt-oauth2-authorize) 
   ;;  (pretty-print (oauth2-post-tweet "qqq" "/home/mbc/projects/babdata/bernays"))
      )))


(main)  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; (use-modules (web client)
;;              (web response)
;;              (web uri)
;;              (web request)
;;              (rnrs bytevectors)
;;              (ice-9 binary-ports)
;;              (ice-9 iconv)
;;              (json)
;;              (oauth oauth)
;;              (oauth oauth1)
;;              (oauth request)
;;              (oauth signature)
;;              (srfi srfi-19)) ; for date-and-time

;; (define (upload-image-to-twitter image-path *oauth-consumer-key* consumer-secret access-token access-token-secret)
;;   (let* ((url "https://upload.twitter.com/1.1/media/upload.json")
;;          (boundary (string-append "------------------------" (number->string (current-time))))
;;          (image-data (call-with-input-file image-path get-bytevector-all))
;;          (image-filename (basename image-path))
;;          (oauth (make-oauth1-credentials
;;                  #:consumer-key *oauth-consumer-key*
;;                  #:consumer-secret consumer-secret
;;                  #:token access-token
;;                  #:token-secret access-token-secret))
;;          (request (oauth1-request
;;                    #:method 'POST
;;                    #:uri (string->uri url)
;;                    #:oauth oauth))
;;          (signed-request (oauth1-sign-request request '()))
;;          (oauth-header (oauth1-auth-header signed-request))
;;          (headers `((Authorization . ,oauth-header)
;;                     (Content-Type . ,(string-append "multipart/form-data; boundary=" boundary))))
;;          (body (string-append
;;                 "--" boundary "\r\n"
;;                 "Content-Disposition: form-data; name=\"media\"; filename=\"" image-filename "\"\r\n"
;;                 "Content-Type: application/octet-stream\r\n\r\n"
;;                 (bytevector->string image-data (make-transcoder (latin1-codec)))
;;                 "\r\n--" boundary "--\r\n")))
;;     (let* ((response (http-post url #:headers headers #:body body))
;;            (json-response (json-string->scm (bytevector->string (response-body response) (make-transcoder (utf8-codec))))))
;;       (assoc-ref json-response "media_id_string"))))

;; ;; Example usage:
;; ;; (define image-id (upload-image-to-twitter 
;; ;;                   "/path/to/your/image.jpg"
;; ;;                   "your-consumer-key"
;; ;;                   "your-consumer-secret"
;; ;;                   "your-access-token"
;; ;;                   "your-access-token-secret"))
;; ;; (display image-id)
