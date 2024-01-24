#lang racket

(require pict3d pict3d/universe math/matrix)

(define (make-rot-matrix a) (matrix (((cos a)     (sin a)  0)
                                     ((- (sin a)) (cos a)  0)
                                     (0           0        1))))

(define (srotate m loc) (let* ([v (matrix (((vector-ref loc 0)) ((vector-ref loc 1)) (1)))]
                               [p (matrix* m v)])
                          (vector (matrix-ref p 0 0) (matrix-ref p 1 0))))

(define camera
  (basis 'camera (point-at (pos 10 8 8) origin)))

(define lights
;   (light (pos 0 0 0) (emitted "orange" 10)))
  (combine
   (light (pos 0 0 0) (emitted "orange" 10))
   (light (pos 7 7 2) (emitted "white" 2))))


(define sunV0 (combine (with-color (rgba "orange") (sphere origin 0.75))
                       (light (pos 1 1 1) (emitted "orange" 10))))

(define sunV1 (with-emitted (emitted "orange" 20) (sphere origin 0.75)))

(define sunV2
  (combine
   (ellipsoid origin (pos 1 1 1))
   (light (pos 0 0 0) (emitted "green" 5))))

(define sunV3 (combine (sphere origin 1)
            (light (pos 0 1.5 1.5) (emitted "oldlace" 5))))

(define sunV4 (combine (sphere origin 1)
            (sunlight (dir -1 2 0) (emitted "orange" 5))))

(define sun sunV3)

(define (earth loc)
  (let ([x (vector-ref loc 0)]
        [y (vector-ref loc 1)]
        [z (vector-ref loc 2)])
    (parameterize ([current-color (rgba "blue")])
      (combine
       (cube (pos+ origin (dir x y z)) 0.3)
       (light (pos (+ 1 x) (+ 1 y) (+ 1 z)) (emitted "white" 2))))))

(define (on-draw s n t)
  (combine sun
           (earth (dict-ref s 'earth-loc))
           camera
           lights))

(define (on-frame s n t)
  (let* ([e-loc (dict-ref s 'earth-loc)]
         [e-m (dict-ref s 'earth-rot-matrix)]
         [2d-e-loc (vector (vector-ref e-loc 0) (vector-ref e-loc 1))]
         [new-2d-e-loc (srotate e-m 2d-e-loc)])
    (dict-set! s 'earth-loc (vector (vector-ref new-2d-e-loc 0) (vector-ref new-2d-e-loc 1) (vector-ref e-loc 2)))
    s))

(define (start) (let ([s (make-hash)])
                  (dict-set! s 'end? #false)
                  (dict-set! s 'earth-loc (vector 6 6 2))
                  (dict-set! s 'earth-rot-matrix (make-rot-matrix 0.01))
                  s))

(define (on-key s n t k)
  (println k)
  (cond
    [(string=? k "q") (dict-set! s 'end? #true) s]
    [else s]))

(define (on-mouse s n t x y k)
  s)

(define (end s n t)
  (dict-ref s 'end?))

;(current-pict3d-legacy? #t)

(big-bang3d (start)
            #:on-key on-key
            #:on-mouse on-mouse
            #:on-draw on-draw
            #:on-frame on-frame
            #:stop-state? end)
