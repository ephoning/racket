#lang racket

(((lambda (x) (x x))
  (lambda (x)
    (lambda (n) (if (zero? n) 1 (* n ((x x) (- n 1)))))))
 5)


(((lambda (improver)
    ((lambda (x) (x x))
     (lambda (x) (improver (lambda (v) ((x x) v))))))
  (lambda (partial)
    (lambda (n) (if (zero? n) 1 (* n (partial(- n 1)))))))
 5)


(define fact-improver
  (lambda (partial)
    (lambda (n) (if (zero? n) 1 (* n (partial(- n 1)))))))

;; Fixpoint combinator
;; applicative order Y-conbinator
(define y
  (lambda (improver)
    ((lambda (x) (x x))
     (lambda (x) (improver (lambda (v) ((x x) v)))))))

;; Y caclulates the fixpoint of an improver function
(define fact (y fact-improver))

;; fact is the fixpoint of fact-improver
(fact-improver fact)

(fact 5)
