#lang racket

(require plot)

(define (f x) (/ (atan x) (/ pi 2)))

(parameterize ([plot-aspect-ratio 1])
               (plot (function f -5 5)))