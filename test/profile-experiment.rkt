#lang racket

(require profile)
;(require profile/render-graphviz)

(define (fac n) 
  (define (_fac n accu)
    (cond [(zero? n) accu]
          [else (_fac (- n 1) (* n accu))]))
  (_fac n 1))


(profile (fac 4000) #:repeat 100)

;profile (fac 4000) #:repeat 100 #:render render)
; todo: get Graphviz renderer to diplsy profiel data graphically?

(time (fac 4000))
