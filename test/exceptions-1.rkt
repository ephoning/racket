#lang racket

(define h1 (hash 'a 1 'b 2 'c 3))

(define h2  (hash-set h1 'c 4))

;(hash-set! h1 'b 42)

(with-handlers ((exn:fail? (lambda (exn) (display "caught exception"))))
  (hash-set! h1 'b 42))
