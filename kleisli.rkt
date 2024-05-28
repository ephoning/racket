#lang racket

; Kleisli: carry enriched data between functiona applications

(define foo
  (λ (x) (* x x)))
(define bar
  (λ (x) (+ x 42)))

; fs: functions
;  x: initial argument
;  a: initial accu
(define kleisli
  (λ (fs x a)
    (if (empty? fs) (list x (reverse a))
        (kleisli (cdr fs) ((car fs) x) (cons (car fs) a)))))

