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






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;guix shell -m manifest.scm guile -- ./twit-post-tweet.scm


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
	  ;; (_ (pretty-print "image-file:"))
	  ;; (_ (pretty-print image-file))
	  ;; (media-id (if image-file (mast-post-image-curl image-file) #f))
	   (media-id (if image-file  (twurl-get-media-id image-file) #f))
	  ;; (_ (pretty-print media-id))
	  ;; (_ (pretty-print *data-dir*))
	   
	   (_ (set-counter new-counter))
	 


	   (stop-time (current-time time-monotonic))
	   (elapsed-time (ceiling (time-second (time-difference stop-time start-time))))
	   )
    (begin
      (pretty-print (string-append "Shutting down after " (number->string elapsed-time) " seconds of use."))
;;    (mast-post-toot-curl-recurse tweets #f media-id 0 hashtags)
      ;;provide clickable url to get pin and authorization code; redirects to oauth2step2, writes access code
            (twitt-oauth2-authorize)
    ;;  (oauth2-post-tweet-recurse tweets media-id #f *data-dir* hashtags 0)
;;      (pretty-print (oauth2-post-tweet "test tweet" "1834901647132065792" #f *data-dir*))
;;     (pretty-print (oauth2-post-tweet "qqq" "/home/mbc/projects/babdata/ellul"))
      )))




	

