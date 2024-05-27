#lang racket

(require plot)
(require math/base)

(define (unit_atan x zoom)
  (* (/ (atan (* x zoom)) pi) 2))

(plot3d (surface3d (λ (x y) (* (unit_atan x 1) (unit_atan y 1)))
                     0 10 0 10)
          #:title "Atan space"
          #:x-label "x" #:y-label "y" #:z-label "unit_atan (x) / unit_atan(y)")
