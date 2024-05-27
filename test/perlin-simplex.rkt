#lang racket

(require images/flomap racket/flonum noise)
(require plot)

(define (clamp min max n)
    (/ (- n min) (- max min)))

(define (build-perlin-image w h #:scale [scale 1.0])
    (flomap->bitmap
     (build-flomap*
      3 w h
      (lambda (x y)
        (define g (clamp -1.0 1.0 (perlin (* scale (/ x w)) (* scale (/ y h)))))
        (vector g g g)))))

(build-perlin-image 256 256 #:scale 10.0)

(define (build-simplex-image w h #:scale [scale 1.0])
    (flomap->bitmap
     (build-flomap*
      3 w h
      (lambda (x y)
        (define g (clamp -1.0 1.0 (simplex (* scale (/ x w)) (* scale (/ y h)))))
        (vector g g g)))))

(build-simplex-image 256 256 #:scale 10.0)

(define (build-colored-simplex-image w h #:scale [scale 1.0])
    (flomap->bitmap
     (build-flomap*
      3 w h
      (lambda (x y)
        (vector
         (clamp -1.0 1.0 (simplex (* scale (/ x w)) (* scale (/ y h)) -1.0))
         (clamp -1.0 1.0 (simplex (* scale (/ x w)) (* scale (/ y h))  0.0))
         (clamp -1.0 1.0 (simplex (* scale (/ x w)) (* scale (/ y h))  1.0)))))))

(build-colored-simplex-image 256 256 #:scale 10.0)

;;(define perlin-noise (perlin/px 5))
(define perlin-noise perlin)
;;(scale (bitmap (apply-bitmap/mono 100 100 perlin-noise)) 5)
(bitmap (apply-bitmap/mono 100 100 perlin-noise))
(plot (contour-intervals perlin-noise 0 100 0 100))
(plot3d (surface3d (scale/px perlin-noise 0 100 0 100)))
