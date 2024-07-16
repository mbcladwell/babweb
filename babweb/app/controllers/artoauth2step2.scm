;; Controller welcome definition of babweb
;; Please add your license header here.
;; This file is generated automatically by GNU Artanis.
(define-module (app controllers artoauth2step2)
  #:use-module (artanis mvc controller)
  #:use-module (artanis utils)
  #:use-module (artanis artanis)
  #:use-module (artanis cookie)
  #:use-module ((rnrs) #:select (define-record-type))
  #:use-module (rnrs bytevectors) 
  #:use-module (artanis irregex)
  #:use-module (srfi srfi-1)
  #:use-module (web uri)	     
  #:use-module (web client)	     
  #:use-module (web http)	     
  #:use-module (gcrypt base64 )	     
  #:use-module (ice-9 pretty-print)
  #:use-module (ice-9 receive)
  #:use-module (babweb lib twitter)
  #:use-module (babweb lib account)
  #:use-module (babweb lib env)
  #:use-module (babweb lib utilities)
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
  
(define-artanis-controller artoauth2step2) ; DO NOT REMOVE THIS LINE!!!


(get "/artoauth2step2"
      #:cookies '(names reqtok sid)
     ;; #:from-post 'qstr
  (lambda (rc)
    (let* (
;;	   (custid (uri-decode (:from-post rc 'get-vals "custid")))
;;	   (code (uri-decode (:from-post rc 'get-vals "code")))
	   (custid (params rc "custid"))
	   (code (params rc  "code"))
	  ;; (_ (:cookies-set! rc 'reqtok "reqtok" request-token))
	  ;; (uri (string-append "https://api.twitter.com/oauth/authenticate?oauth_token=" request-token))
	   (response (get-access-token-curl code))
	   )
       (view-render "artoauth2step2" (the-environment)))
;;	  (redirect-to rc  "/twittacceptpin" ))
  ))

   
;;https://developer.x.com/en/docs/authentication/oauth-2-0/user-access-token   PKCE instructions

;;https://api.x.com/oauth/authenticate?oauth_token=UvaijAAAAAABhb0tAAABkFlLYAs
(define (get-access-token code)
  (let* ((uri "https://api.twitter.com/2/oauth2/token")
	 (redirect-uri "https://build-a-bot.biz/bab/oauth2step3.php")
	 (nonce1 (get-nonce 10 ""))
	 (nonce2 (get-nonce 10 ""))
	;; (code "V20wZ0lJTERFLXVwTXYyMzloNXNmLXBjV2VMSG8tUUFZOEVDV2NEQzZVekJkOjE3MjEwNDA5NjU0MzY6MToxOmFjOjE")
	 (auth (base64-encode (string->utf8 (string-append *client-id* ":" *client-secret*))))
	 (response     (receive (response body)
      			    (oauth2-client-access-token-from-code uri code
								  #:client-id *client-id*
								  #:redirect-uri redirect-uri
								  #:auth '()
								  #:extra-headers `((code_verifier . ,nonce1)
										    (code_challenge . ,nonce2)
										    (code_challenge_method . "plain")
										    (token_type_hint . "access_token"))
								  #:http-proc http-request
								  )
			 (utf8->string response))
		       )
	 )
response))


      
;; curl --location --request POST 'https://api.twitter.com/2/oauth2/token' \
;; --header 'Content-Type: application/x-www-form-urlencoded' \
;; --data-urlencode 'code=VGNibzFWSWREZm01bjN1N3dicWlNUG1oa2xRRVNNdmVHelJGY2hPWGxNd2dxOjE2MjIxNjA4MjU4MjU6MToxOmFjOjE' \
;; --data-urlencode 'grant_type=authorization_code' \
;; --data-urlencode 'client_id=rG9n6402A3dbUJKzXTNX4oWHJ' \
;; --data-urlencode 'redirect_uri=https://www.example.com' \
;; --data-urlencode 'code_verifier=challenge'

;;https://stackoverflow.com/questions/77725780/error-fetching-oauth-credentials-missing-required-parameter-code-verifier

;;this worked!!
    (define (get-access-token-curl code)
  (let*(;;(media-id (mast-post-image-curl i))
;;	(media (if i (string-append "' --data-binary 'media_ids[]=" i ) ""))
;;	(reply (if r (string-append "' --data-binary 'in_reply_to_id=" r ) ""))
	(redirect-uri "https://build-a-bot.biz/bab/oauth2step2.php")
	 (nonce1 (get-nonce 10 ""))	
	(out-file (get-rand-file-name "f" "txt"))
	(command (string-append "curl -o " out-file " --location --request POST 'https://api.twitter.com/2/oauth2/token' --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'code=" code "' --data-urlencode 'grant_type=authorization_code' --data-urlencode 'token_type_hint=access_token' --data-urlencode 'client_id=" *client-id* "' --data-urlencode 'redirect_uri=" redirect-uri "' --data-urlencode 'code_verifier=abcdefgh'"))
	(_ (pretty-print command))
	(_ (system command))
;;	(_ (sleep 3))
;;	(p  (open-input-file out-file))
;;	(lst  (json-string->scm (get-string-all p)))
;;      	(in (open-pipe*  OPEN_READ "curl" "-v" "-o" out-file "-H" bearer "-X" "POST" "-H" "'Content-Type: multipart/form-data'" "https://mastodon.social/api/v2/media" "--form" image))
;;	(id (assoc-ref lst "id"))
;;	(_ (delete-file out-file))
	(_ (pretty-print (string-append "file: " out-file)))
	)
  #f ))


;;step 4 tweet  https://developer.x.com/en/docs/twitter-api/tweets/manage-tweets/api-reference/post-tweets
      
;;curl --location --request GET 'https://api.twitter.com/2/tweets?ids=1261326399320715264,1278347468690915330' \
;;--header 'Authorization: Bearer Q0Mzb0VhZ0V5dmNXSTEyNER2MFNfVW50RzdXdTN6STFxQlVkTGhTc1lCdlBiOjE2MjIxNDc3NDM5MTQ6MToxOmF0OjE'


curl --location --request POST 'https://api.twitter.com/2/tweets' \
--header 'Authorization: Bearer WWE1NG1Bd01xd3U1Tm0wTmh5WHRuSG90WFNWTUxQN0xOMmNXR2ZmM19IQ2d2OjE3MjExNTc5NjEyODY6MToxOmF0OjE' \
--header 'Content-Type: application/json' \
 --data '{"text":"Hello World!"}'

    
