#lang racket


(require 2htdp/universe 2htdp/image math/matrix) 


(define (make-rot-matrix a) (matrix (((cos a)     (sin a)  0)
                                     ((- (sin a)) (cos a)  0)
                                     (0           0        1))))

(define (srotate m pos) (let* ([v (matrix (((vector-ref pos 0)) ((vector-ref pos 1)) (1)))]
                               [p (matrix* m v)])
                          (vector (matrix-ref p 0 0) (matrix-ref p 1 0))))

(define (generate-numeric-sequence start end step accu)
  (cond [(> (+ start step) end) accu]
        [else ]))
(define (generate-grid-markers interval count accu)
  (cond [(zero? count) accu]
        [else ]))
(define backdrop (empty-scene 400 400 "grey"))
; objects: (<shape> <abs/rel pos> <rotation matrix>)
(define sun    (vector (circle 50 "solid" "orange") (vector 200 200) 'nil))
(define earth  (vector (circle 15 "solid" "blue")   (vector 90 90)   (make-rot-matrix 0.01)))
(define moon   (vector (circle 5 "solid" "white")   (vector 30 30)   (make-rot-matrix -0.04)))
(define rocket (vector (circle 2 "solid" "red")     (vector 10 10)   (make-rot-matrix 0.08)))
(define grid_markers `(,(vector (square 2 "solid" "black") (vector 10 10) 'nil)
                       ,(vector (square 2 "solid" "black") (vector 15 15) 'nil)
                       ,(vector (square 2 "solid" "black") (vector 20 20) 'nil)
                       ,(vector (square 2 "solid" "black") (vector 25 25) 'nil)
                       ))


(define (extract-element objects idx) (cond [(empty? objects) '()]
                                            [else (cons (vector-ref (car objects) idx) (extract-element (cdr objects) idx))]))
(define (extract-images objects) (extract-element objects 0))
(define (extract-poss objects) (extract-element objects 1))

; calc absolute position of each object
; list<object> -> list<abs pos>
(define (abs-poss poss accu) (cond [(empty? poss) '()]
                                      [else (let ([curr-abs-pos (vector-map + (car poss) accu)])
                                              (cons curr-abs-pos (abs-poss (cdr poss) curr-abs-pos)))]))

(define (compose-images images poss accu)
  (cond [(empty? images) accu]
        [else (let ([image (car images)]
                    [pos (car poss)])
                (compose-images (cdr images) (cdr poss) (place-image image (vector-ref pos 0) (vector-ref pos 1) accu)))]))

(define (compose-scene objects)
    (compose-images (extract-images objects) (abs-poss (extract-poss objects) (vector 0 0)) backdrop))

(define (start) (let ([w (make-hash)])
                  (dict-set! w 'end? #false)
                  (dict-set! w 'objects (append grid_markers `(,sun ,earth ,moon ,rocket)))
                  (dict-set! w 'scene (compose-scene (dict-ref w 'objects)))
                  w))

(define (rotate-object object) (let* ([image (vector-ref object 0)]
                                      [pos (vector-ref object 1)]
                                      [rot-matrix (vector-ref object 2)]
                                      [new-pos (srotate rot-matrix pos)])
                                 (vector image new-pos rot-matrix)))

(define (rotate-objects objects) (cond [(empty? objects) '()]
                                       [else (cons (rotate-object (car objects)) (rotate-objects (cdr objects)))]))

(define (maybe-mod-objects objects)
  (let ([msg (thread-try-receive)])
    (cond [msg (display "GOT MSG")]
          [(and msg (eq? (car msg) 'earth)) (begin (display "GOT MSG") objects) ]
          [else objects])))

(define (do-tick w) (let* ([objects (dict-ref w 'objects)]
                           [static_objs_len (+ 1 (length grid_markers))]
                           [static_objects (take objects static_objs_len)]
                           [to_rotate_objects (drop objects static_objs_len)]
                           [rotated-objects (append static_objects (rotate-objects to_rotate_objects))])
                      (dict-set! w 'objects rotated-objects)
                      (dict-set! w 'scene (compose-scene rotated-objects))
		      (dict-set! w 'objects (maybe-mod-objects rotated-objects))
                      w))

(define (do-key w kEvent) (cond
                            [(key=? kEvent "q") (dict-set! w 'end? #true) w]
                            [else w]))

(define (do-draw w) (dict-ref w 'scene))

(define (do-end w) (dict-ref w 'end?))

(define (start-universe) (big-bang
                             (start)
                           (on-tick do-tick)
                           (on-key do-key)
                           (on-draw do-draw)
                           (stop-when do-end)
                           (close-on-stop 10)))


;; start running per:
;; (define t (thread start-universe))
;; send msg with new 'earth' per:
;; (thread-send t `(earth (vector (circle 20 "solid" "green")   (vector 90 90)   (make-rot-matrix 0.01))))


