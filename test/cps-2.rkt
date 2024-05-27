#lang racket


(define fact$ (lambda (n k) (if (zero? n) (k 1) (fact$ (- n 1) (lambda (x) (k (* n x)))))))

(fact$ 5 (lambda (x) x))

(fact$ 5 list)

(fact$ 5 (lambda (5!) `(result is ,5!)))

