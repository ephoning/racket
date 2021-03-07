#lang racket

(require plot)

(plot3d (list
           (parametric-surface3d
            (λ (θ φ)
              (list (* (+ 5 (sin φ)) (sin θ))
                    (* (+ 5 (sin φ)) (cos θ))
                    (+ 0 (cos φ))))
            0 (* 2 pi) #:s-samples 50
            0 (* 2 pi)
            #:label "torus1")
           (parametric-surface3d
            (λ (θ φ)
              (list (+ 4 (* (+ 3 (sin φ)) (sin θ)))
                    (+ 0 (cos φ))
                    (* (+ 3 (sin φ)) (cos θ))))
            0 (* 2 pi) #:s-samples 30
            0 (* 2 pi)
            #:color 4
            #:label "torus2"))
          #:z-min -6 #:z-max 6
          #:altitude 22)


(parameterize ([plot-decorations?  #f]
                 [plot3d-samples     75])
    (define (f1 θ φ) (+ 1 (/ θ 2 pi) (* 1/8 (sin (* 8 φ)))))
    (define (f2 θ φ) (+ 0 (/ θ 2 pi) (* 1/8 (sin (* 8 φ)))))
  
    (plot3d (list (polar3d f1 #:color "navajowhite"
                           #:line-style 'transparent #:alpha 2/3)
                  (polar3d f2 #:color "navajowhite"
                           #:line-style 'transparent #:alpha 2/3))))


(define ((dist cx cy cz) x y z)
    (sqrt (+ (sqr (- x cx)) (sqr (- y cy)) (sqr (- z cz)))))
(plot3d (list (isosurface3d (dist  1/4 -1/4 -1/4) 0.995
                              #:color 4 #:alpha 0.8 #:samples 21)
                (isosurface3d (dist -1/4  1/4  1/4) 0.995
                              #:color 6 #:alpha 0.8 #:samples 21))
          #:x-min -1 #:x-max 1
          #:y-min -1 #:y-max 1
          #:z-min -1 #:z-max 1
          #:altitude 25)
