#! /home/mbc/.guix-profile/bin/guile \
-e main -s
!#
;;(add-to-load-path "/home/mbc/temp/test")
(add-to-load-path "/home/mbc/projects/babweb")
(add-to-load-path "/home/mbc/projects/babweb/babweb")
(add-to-load-path "/home/mbc/projects/guile-oauth")

(use-modules (web client) (web response)(web request) (web uri)(web http)
	     (srfi srfi-19) ;; date time
	     (srfi srfi-1)  ;;list searching; delete-duplicates in list 
	     (srfi srfi-9)  ;;records
	     (ice-9 rdelim)
	     (ice-9 i18n)   ;; internationalization
	     (ice-9 popen)
	     (ice-9 regex) ;;list-matches
	     (ice-9 receive)	     
	     (ice-9 string-fun)  ;;string-replace-substring
	     (ice-9 pretty-print)
	     (ice-9 textual-ports)
;;	     (ice-9 readline)
	     (ice-9 binary-ports)
	     (json)
	     (gcrypt base64)(gcrypt hmac)
	     (oauth oauth1)(oauth oauth1 client) (oauth oauth1 utils) (oauth oauth1 credentials) (oauth oauth1 signature)
	     (oauth oauth2)(oauth oauth2 request)(oauth oauth2 response)	     	     
	     (oauth utils)(oauth request)	     
	     (rnrs bytevectors)
	     (babweb lib env)(babweb lib image) (babweb lib utilities)(babweb lib twitter)
	     )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Free account is app only OAUTH 2.0 with PKCE
;;https://developer.x.com/en/docs/authentication/oauth-2-0/authorization-code

;;(define callback-url "https://build-a-bot.biz/bab/callback1.php")
(define basic-creds (base64-encode (string->utf8 (string-append *client-id* ":" *client-secret*))))

;;basic-creds: V0ZvM2JVZDBaVFJYVFhOYVNuRTRNV1oxUjJVNk1UcGphUTpmZFM2ZUwwNEUxM3A4b1NTR0dtRWpzeXpFOE5naWkxWXZwaUJ4RWdNeUJVWl9DWGZnSw==

;;https://developer.x.com/en/docs/authentication/oauth-2-0/user-access-token   PKCE instructions
;;step 1  tweet.write%20offline.access

;;step 2    auth_code good for 30 seconds
(define (twitt-oauth2-authorize)
  (let*((callback-url "http://127.0.0.1:3000/oauth2step2")
	(uri (string-append "https://twitter.com/i/oauth2/authorize?response_type=code&client_id=" *client-id* "&redirect_uri=" callback-url "&scope=tweet.write%20tweet.read%20users.read%20offline.access&state=abcdefgh&code_challenge=abcdefgh&code_challenge_method=plain"   ))
;;	(command (string-append "firefox " uri))
      )
   ;; (system command)
(pretty-print uri)
    ))

;;https://twitter.com/i/oauth2/authorize?response_type=code&client_id=M1M5R3BMVy13QmpScXkzTUt5OE46MTpjaQ&redirect_uri=https://www.example.com&scope=tweet.read%20users.read%20follows.read%20follows.write&state=state&code_challenge=challenge&code_challenge_method=plain

;;returns: https://build-a-bot.biz/bab/register2.php?state=abcdefgh&code=V20wZ0lJTERFLXVwTXYyMzloNXNmLXBjV2VMSG8tUUFZOEVDV2NEQzZVekJkOjE3MjEwNDA5NjU0MzY6MToxOmFjOjE


;;Step 5: POST oauth2/token - refresh token
      
;; POST 'https://api.twitter.com/2/oauth2/token' \
;; --header 'Content-Type: application/x-www-form-urlencoded' \
;; --data-urlencode 'refresh_token=bWRWa3gzdnk3WHRGU1o0bmRRcTJ5VUxWX1lZTDdJSUtmaWcxbTVxdEFXcW5tOjE2MjIxNDc3NDM5MTQ6MToxOnJ0OjE' \
;; --data-urlencode 'grant_type=refresh_token' \
;; --data-urlencode 'client_id=rG9n6402A3dbUJKzXTNX4oWHJ'


;; (define (oauth2-post-tweet  text )
;;   ;;https://developer.twitter.com/en/docs/authentication/oauth-1-0a/authorizing-a-request
;;   ;;https://developer.twitter.com/en/docs/authentication/oauth-1-0a/creating-a-signature
;;   (let* (
;; 	 (oauth1-response (make-oauth1-response *oauth-access-token* *oauth-token-secret* '(("user_id" . "1516431938848006149") ("screen_name" . "eddiebbot")))) ;;these credentials do not change
;; 	 (credentials (make-oauth1-credentials *oauth-consumer-key* *oauth-consumer-secret*))
;; 	 (data (string-append "{\"text\": \"" text "\"}"))
;;  	 (uri  "https://api.twitter.com/2/tweets")
;; 	 (tweet-request (make-oauth-request uri 'POST '()))
;; 	 (dummy (oauth-request-add-params tweet-request `( 
;; 	  						  (oauth_consumer_key . ,*oauth-consumer-key*)
;; 							 ; (oauth_consumer_secret . ,*oauth-consumer-secret*)
;; 							 ; (oauth_token_secret .,*oauth-token-secret*)
;; 							  (oauth_nonce . ,(oauth1-nonce))
;; 							  (oauth_timestamp . ,(oauth1-timestamp))
							
;; 							   (oauth_token . ,*oauth-access-token*)
;; 							   (oauth_version . "1.0")
;; 							   (response_type . "code")
;; 							   (client_id . ,*client-id*)
							   
;; 							  ; (Content-type . "application/json")
;; 							  ; (json . ,data)
;; 							   )))
;; 	 (dummy (oauth1-request-sign tweet-request credentials oauth1-response #:signature oauth1-signature-hmac-sha1))
;; 	 (dummy (oauth-request-add-param tweet-request 'content-type "application/json"))
;; ;;	 (dummy (oauth-request-add-param tweet-request 'Authorization "Bearer"))
;; 	 (dummy (oauth-request-add-param tweet-request 'scope "tweet.write"))
	 
;; 	 )
;;     (oauth2-http-request tweet-request #:body data )))

(define (oauth2-post-tweet  text media-id reply-id data-dir)
  ;;  (oauth2-post-tweet  "hello world" #f #f *data-dir*)
  ;;https://developer.twitter.com/en/docs/authentication/oauth-1-0a/authorizing-a-request
  ;;https://developer.twitter.com/en/docs/authentication/oauth-1-0a/creating-a-signature
  ;;https://mail.gnu.org/archive/html/guile-user/2017-07/msg00067.html   talks about application/json
  (let* (
	 (uri  "https://api.twitter.com/2/tweets")
	 (access-token (repeat-get-access-token data-dir))
	(bearer (string-append "Bearer " access-token))
	(lst `(("text". ,text)))
	(lst (if media-id
		 (reverse (acons "media" (vector media-id) lst))
		 lst))
	(lst (if reply-id
		 (reverse (acons "reply" `(("in_reply_to_tweet_id" .  ,reply-id)) lst))
		 lst))
	(data (scm->json-string lst)))
    (http-request uri 
		  #:method 'POST
		  #:headers `((content-type . (application/json))					     
			      (authorization . ,(parse-header 'authorization bearer)))
		  #:body data )))


(define (oauth2-post-tweet-recurse lst reply-id media-id data-dir counter)
  ;;list of tweets to post
  ;;reply-id initially #f
  ;;counter initially 0; counter is needed to identify reply-id in first round and use media-id if exists
  (if (null? (cdr lst))
      (oauth2-post-tweet (car lst) #f #f data-dir )
      (if (eqv? counter 0)
	  (begin
	    (receive (response body)	  
		(oauth1-post-tweet (car lst) media-id reply-id data-dir)
	      (set! counter (+ counter 1))
	      ;; (pretty-print (cdr lst))
	      ;; (pretty-print (assoc-ref  (json-string->scm (utf8->string body)) "id_str"))
	      ;; (pretty-print media-id)
	      ;; (pretty-print counter)

	      (oauth2-post-tweet-recurse  (cdr lst) (assoc-ref  (json-string->scm (utf8->string body)) "id_str")  media-id data-dir  counter)))
	  (begin
	    (receive (response body)	  
		(oauth2-post-tweet (car lst) media-id reply-id data-dir )
	       (set! counter (+ counter 1))
	     (oauth2-post-tweet-recurse  (cdr lst) (assoc-ref  (json-string->scm (utf8->string body)) "id_str")  media-id data-dir counter))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;guix shell -m manifest.scm guile -- guile ./twit-post-tweet.scm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (main args)
  (let* ((start-time (current-time time-monotonic))
	;; (_ (pretty-print (cadr args)))
	  (counter (get-counter))
	  (all-excerpts (get-all-excerpts-alist))
	  (max-id (assoc-ref (car all-excerpts) "id"))
	  (new-counter (if (= counter max-id) 0 (+ counter 1)))
          (entity (find-by-id all-excerpts new-counter))	 
	  (tweets (chunk-a-tweet (assoc-ref entity "content") *tweet-length*))
	  (hashtags (get-all-hashtags-string))

	  (media-directive (assoc-ref entity "image"))
	  (image-file (if (string=? media-directive "none") #f (get-image-file-name media-directive)))
	  (media-id (if image-file (mast-post-image-curl image-file) #f))
	  (_ (set-counter new-counter))
	 


	 (stop-time (current-time time-monotonic))
	 (elapsed-time (ceiling (time-second (time-difference stop-time start-time))))
	 )
    (begin
      (pretty-print (string-append "Shutting down after " (number->string elapsed-time) " seconds of use."))
    (mast-post-toot-curl-recurse tweets #f media-id 0 hashtags)
      ;;provide clickable url to get pin and authorization code; redirects to oauth2step2, writes access code
;;      (twitt-oauth2-authorize) 
   ;;  (pretty-print (oauth2-post-tweet "qqq" "/home/mbc/projects/babdata/bernays"))
      )))




	

