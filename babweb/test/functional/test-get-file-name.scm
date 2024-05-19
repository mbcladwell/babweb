
(add-to-load-path "/home/mbc/temp/test")
(add-to-load-path "/home/mbc/projects/conmanv4")

(use-modules (web client)
	     (srfi srfi-19)   ;; date time
	     (srfi srfi-1)  ;;list searching; delete-duplicates in list 
	     (ice-9 pretty-print)
	     (ice-9 regex) ;;list-matches
	     (ice-9 string-fun)  ;;string-replace-substring	   
	     (ice-9 textual-ports))


(define (get-file-name s)
  ;;expecting <p>Upload succeeded! 11391: kingdomcome.zip bytes!</p>
  (let* ((b (string-contains s "bytes!</p>"))
	 (c  (substring s 0 (- b 1)))
	 (d (string-index c #\:))
	 )
    (if (= d 22) "null" (substring c (+ d 2) (string-length c)))
    ))

(define (booboo)
  (let* (
	 (a "<p>Upload succeeded! 11391: kingdomcome.zip bytes!</p><p>Upload succeeded! 654468: randoms.zip bytes!</p><p>Upload succeeded! 2512: destination.txt bytes!</p>) (<p>Upload succeeded! 11391: kingdomcome.zip bytes!</p><p>Upload succeeded! 654468: randoms.zip bytes!</p><p>Upload succeeded! 2512: destination.txt bytes!</p>")
	 (b "<p>Upload succeeded! 11391: kingdomcome.zip bytes!</p><p>Upload succeeded! 0: bytes!</p><p>Upload succeeded! 0: bytes!</p>) (<p>Upload succeeded! 11391: kingdomcome.zip bytes!</p><p>Upload succeeded! 654468: randoms.zip bytes!</p><p>Upload succeeded! 2512: destination.txt bytes!</p>")
	 
	;; (a '( ("ext" . "txt") ("hash" . "1234") ))
	 (s (string-match "</p>" b ))
	 (file1 (get-file-name (substring b 0 (match:end s))))
	 (rest (substring b  (match:end s)))
	 (s (string-match "</p>" rest ))
	 (file2 (get-file-name (substring rest 0 (match:end s))))
	 (rest (substring rest  (match:end s)))
	 (s (string-match "</p>" rest ))
	 (file3 (get-file-name (substring rest 0 (match:end s))))	 
	 )
     (list file3 file2 file1)
  ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;guix shell guile conmanv4 -- guile -L /home/mbc/temp/tests ./test.scm
;;guix shell guile -- guile -L /home/mbc/temp/tests -L ./test.scm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (main)
  ;; args: '( "script name" "past days to query" "Number of articles to pull")
  (let* ((start-time (current-time time-monotonic))	 
	 (stop-time (current-time time-monotonic))
	 (elapsed-time (ceiling (time-second (time-difference stop-time start-time))))
	 
	 )
    (begin
      (pretty-print (booboo))
      (pretty-print (string-append "Shutting down after " (number->string elapsed-time) " seconds of use."))
    )))
   

(main)


