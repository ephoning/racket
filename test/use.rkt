#lang racket

(require "quick.rkt")
(require slideshow)
(require slideshow/code)

(rainbow (square 5))


;; note: does not work: 'code' output picture of 'p'
(define (p+c p)
  (hc-append 10 p (code p)))

;; this does work, as 'expr' is not evaluated, but substituted prior
;; to evaluation in 'expr' as featured in (code expr)
(define-syntax p+c-macro
  (syntax-rules ()
    [(p+c-macro expr)
     (hc-append 10 expr (code expr))]))
