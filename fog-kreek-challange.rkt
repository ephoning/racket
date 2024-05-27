#lang racket

; see: http://www.fogcreek.com/Jobs/Dev/

(require srfi/13) ; string functions

(define letters "acdegilmnoprstuw")
  
(define (unhash v) 
  (_unhash v "")) ; start with empty accu

(define (_unhash v a)
  (let ((idx (modulo v 37)))
    (cond ((= v 7) a)
          (true (_unhash (/ (- v idx) 37)
                         (string-concatenate `(,(string (string-ref letters idx)) ,a)))))))
  
