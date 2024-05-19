#lang racket

(require minikanren)

(define (≡ a b) (== a b))

(run* (q) (== 1 1))

(run* (q) (≡ q 42))
