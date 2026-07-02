#lang racket

(define *k* '())

(+ (call/cc
    (λ (k) (k (* 3 4))))
   5)

(+ (call/cc
    (λ (k)
      (begin
        (set! *k* k)
        (k (* 3 4)))))
   5)


;; note the division is not executee
(call/cc
 (λ (k) (/ 5 (k 0))))

;; note that 'error' is not executed - we jump out of the expression
(call/cc
 (λ (k) (error (k 0))))


(let ([x (call/cc (λ (k) k))])
  (x (λ (ignore) "hi")))

(((call/cc (λ (k) k)) (λ (x) x)) "HEY!")