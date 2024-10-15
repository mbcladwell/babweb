;; Controller welcome definition of babweb
;; Please add your license header here.
;; This file is generated automatically by GNU Artanis.
(define-module (app controllers oauth2step2)
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
  #:use-module (ice-9 textual-ports)
;;  #:use-module (babweb lib twitter)
  #:use-module (babweb lib account)
;;  #:use-module (babweb lib utilities)
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
  
(define-artanis-controller oauth2step2) ; DO NOT REMOVE THIS LINE!!!

;;must be in developers portal setup as valid callback
(get "/oauth2step2"
      #:cookies '(names reqtok sid)
     ;; #:from-post 'qstr
  (lambda (rc)
    (let* (
;;	   (custid (uri-decode (:from-post rc 'get-vals "custid")))
;;	   (code (uri-decode (:from-post rc 'get-vals "code")))
	  ;; (custid (params rc "state"))
	   ;;code is from
	   (_ (pretty-print (string-append "datadir: " *data-dir*)))
	   (authorization-code (params rc  "code"))
	  ;; (_ (:cookies-set! rc 'reqtok "reqtok" request-token))
	  ;; (uri (string-append "https://api.twitter.com/oauth/authenticate?oauth_token=" request-token))
	   (_ (init-get-access-token authorization-code *client-id* *redirecturi* *data-dir*))
	   ;;init-get-access-token will write oauth1_access_token_envs
	   ;;(access-token (assoc-ref response "access_token"))
	   ;;(expires-in (assoc-ref response "expires_in"))
	   ;;(refresh-token (assoc-ref response "refresh_token"))
	   (_ (pretty-print "response next:"))
	 ;;  (_ (pretty-print response))
	   ;;test tweet
	  ;; (_ (oauth2-post-tweet "test tweet inside art/oauth2-step2" *data-dir*))
	   )
      ;; (view-render "oauth2step2" (the-environment)))
      
      (redirect-to rc  (string->uri "https://build-a-bot.biz/bab/welcome.php" )))
  ))

   


;;step 4 tweet  https://developer.x.com/en/docs/twitter-api/tweets/manage-tweets/api-reference/post-tweets
      
;;curl --location --request GET 'https://api.twitter.com/2/tweets?ids=1261326399320715264,1278347468690915330' \
;;--header 'Authorization: Bearer Q0Mzb0VhZ0V5dmNXSTEyNER2MFNfVW50RzdXdTN6STFxQlVkTGhTc1lCdlBiOjE2MjIxNDc3NDM5MTQ6MToxOmF0OjE'

;; this works!!
;; curl --location --request POST 'https://api.twitter.com/2/tweets' \
;; --header 'Authorization: Bearer cWVacGlUSnJWRmt0UkZKTVAyNVRQZDRzOGh6dUtkUGswcWJ4U2FUQVRPaUh4OjE3MjE3MzI5NjAyNTA6MToxOmF0OjE' \
;; --header 'Content-Type: application/json' \
;;  --data '{"text":"Hello World!"}'

;;response  {"token_type":"bearer","expires_in":7200,"access_token":"WWE1NG1Bd01xd3U1Tm0wTmh5WHRuSG90WFNWTUxQN0xOMmNXR2ZmM19IQ2d2OjE3MjExNTc5NjEyODY6MToxOmF0OjE","scope":"tweet.write users.read tweet.read offline.access","refresh_token":"Q2ZQaXppZWxtY0dCdGlDRmlrWDA2dWFxYm05S0EwanFtZTN6ZExxUkRvSW1FOjE3MjExNTc5NjEyODY6MTowOnJ0OjE"}    

;;step 5 refresh token

;;this works      
;; curl --location --request POST 'https://api.twitter.com/2/oauth2/token' \
;; --header 'Content-Type: application/x-www-form-urlencoded' \
;; --data-urlencode 'refresh_token=Q2ZQaXppZWxtY0dCdGlDRmlrWDA2dWFxYm05S0EwanFtZTN6ZExxUkRvSW1FOjE3MjExNTc5NjEyODY6MTowOnJ0OjE' \
;; --data-urlencode 'grant_type=refresh_token' \
;; --data-urlencode 'client_id=WFo3bUd0ZTRXTXNaSnE4MWZ1R2U6MTpjaQ'

;;    {"token_type":"bearer","expires_in":7200,"access_token":"OC1Jd0IwRmN1SkFRT3Q1YXlUWHZmYjRTQVo2U19FZWRWeFluUE5LVDFYWXM1OjE3MjEyMTQ3MTA1MzM6MToxOmF0OjE","scope":"tweet.write users.read tweet.read offline.access","refresh_token":"dlpHVXk2cEVwWEdxTWpSRk1YbUxackhWLTJYdXRiWHpacVpfZk9TTHpIeEVhOjE3MjEyMTQ3MTA1MzQ6MTowOnJ0OjE"}
