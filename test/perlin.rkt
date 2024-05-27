#lang racket

(require plot noise)

(define ci2 (lambda ()
      (contour-intervals perlin -3 3 -3 3 
                         #:samples 500
                         #:levels 20)))

(define 2d (lambda ()
(plot (contour-intervals perlin -3 3 -3 3 
                         #:samples 500
                         #:levels 20)
      #:x-min -3 #:x-max 3
      #:y-min -3 #:y-max 3)))


(define 3d (lambda ()
(plot3d (contour-intervals3d perlin
                         #:samples 500
                         #:levels 10
                         #:colors '("red" "green" "blue"))
      #:x-min -2 #:x-max 2
      #:y-min -2 #:y-max 2
      #:z-min -2 #:z-max 2)))


