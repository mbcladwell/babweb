(add-to-load-path "/home/mbc/projects/babweb")
(add-to-load-path "/home/mbc/projects/babweb/babweb")
(add-to-load-path "/home/mbc/projects/guile-oauth")
(add-to-load-path "/home/mbc/projects/guile-gcrypt")


(use-modules (web client)
             (web response)
             (web uri)
             (web request)
             (rnrs bytevectors)
             (ice-9 binary-ports)
	    (gcrypt hmac)
	    (gcrypt base64)
             (ice-9 iconv)
             (json)
	     (oauth oauth1)(oauth oauth1 client) (oauth oauth1 utils) (oauth oauth1 credentials) (oauth oauth1 signature)
	     (oauth oauth2)(oauth oauth2 request)(oauth oauth2 response)	     	     
	     (oauth utils)(oauth request)	     
	     (babweb lib env)(babweb lib image) (babweb lib utilities)(babweb lib twitter)
	     (rnrs io ports)
	     (ice-9 pretty-print)
	     (srfi srfi-19)) ; for date-and-time


(define (hmac-sha1-signature base-string )
  (let ((key (string-append (uri-encode *oauth-consumer-secret*)
                 "&"
                 (uri-encode *oauth-token-secret*))))
    (sign-data-base64 key base-string #:algorithm 'sha1)))


;;guile -l "up-image.scm" -c '(upload-image-to-twitter "/home/mbc/Pictures/scope.jpeg")'

(define (upload-image-to-twitter image-path)
  (let* (
	 (oauth1-response (make-oauth1-response *oauth-access-token* *oauth-token-secret* '(("user_id" . "1516431938848006149") ("screen_name" . "eddiebbot")))) ;;these credentials do not change	
	 (credentials (make-oauth1-credentials *oauth-consumer-key* *oauth-consumer-secret*))
	 (url "https://upload.twitter.com/1.1/media/upload.json")
	 (image-request (make-oauth-request url 'POST '()))
         (boundary (string-append "------------------------" (number->string (time-second (current-time)))))
         (image-data (call-with-input-file image-path get-bytevector-all))
         (image-filename (basename image-path))
	 ;;;;;;;;;;;;;;
	 (size-in-bytes (number->string (stat:size (stat image-path))))
	 (p (open-input-file image-path))
 	 (bytes (get-bytevector-all p))	 
 	 (bytes64 (base64-encode bytes))
 	 (dummy (close-port p))
	 (urlen-bytes64 (uri-encode bytes64))
	 (data (string-append "media_data=" bytes64))
	 (urlen-bytes64-hash (hmac-sha1-signature urlen-bytes64 ))
	 ;;;;;;;;;;
   	 (dummy (oauth-request-add-params image-request `( 
	  						   (oauth_consumer_key . ,*oauth-consumer-key*)
							   (oauth_nonce . ,(oauth1-nonce))
							   (oauth_timestamp . ,(oauth1-timestamp))
							   (oauth_token . ,*oauth-access-token*)
							  ;; (oauth_body_hash . ,body-hash)
							   (oauth_version . "1.0")
							   ) ))
	 (dummy (oauth1-request-sign image-request credentials oauth1-response #:signature oauth1-signature-hmac-sha1))

	 (body (string-append
                "--" boundary "\r\n"
                "Content-Disposition: form-data; name=\"media_data\"; filename=\"" image-filename "\"\r\n"
   ;;             "Content-Type: application/octet-stream\r\n\r\n"
                "Content-Type: multipart/form-data\r\n\r\n"
		urlen-bytes64
;;                (bytevector->string image-data (make-transcoder (latin-1-codec)))
                "\r\n--" boundary "--\r\n")))

(pretty-print (oauth1-http-request image-request #:params-location 'header #:body body ))
    ))

    



