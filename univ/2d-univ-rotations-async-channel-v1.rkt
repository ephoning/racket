#lang racket


(require 2htdp/universe 2htdp/image math/matrix racket/async-channel) 


(define (make-rot-matrix a) (matrix (((cos a)     (sin a)  0)
                                     ((- (sin a)) (cos a)  0)
                                     (0           0        1))))

(define (srotate m pos) (let* ([v (matrix (((vector-ref pos 0)) ((vector-ref pos 1)) (1)))]
                               [p (matrix* m v)])
                          (vector (matrix-ref p 0 0) (matrix-ref p 1 0))))

(define backdrop (empty-scene 400 400 "grey"))
; objects: (<shape> <abs/rel pos> <rotation matrix>)
(define sun    (vector (circle 50 "solid" "orange") (vector 200 200) 'nil))
(define earth  (vector (circle 15 "solid" "blue")   (vector 90 90)   (make-rot-matrix 0.01)))
(define moon   (vector (circle 5 "solid" "white")   (vector 30 30)   (make-rot-matrix -0.04)))
(define rocket (vector (circle 2 "solid" "red")     (vector 10 10)   (make-rot-matrix 0.08)))

(define (extract-element objects idx) (cond [(empty? objects) '()]
                                            [else (cons (vector-ref (car objects) idx) (extract-element (cdr objects) idx))]))
(define (extract-images objects) (extract-element objects 0))
(define (extract-poss objects) (extract-element objects 1))

(define w (make-hash))

(define c (make-async-channel))

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

(define (start)
  (dict-set! w 'end? #false)
  (dict-set! w 'objects `(,sun ,earth ,moon ,rocket))
  (dict-set! w 'scene (compose-scene (dict-ref w 'objects)))
  w)

(define (rotate-object object) (let* ([image (vector-ref object 0)]
                                      [pos (vector-ref object 1)]
                                      [rot-matrix (vector-ref object 2)]
                                      [new-pos (srotate rot-matrix pos)])
                                 (vector image new-pos rot-matrix)))

(define (rotate-objects objects) (cond [(empty? objects) '()]
                                       [else (cons (rotate-object (car objects)) (rotate-objects (cdr objects)))]))

;; a no-op for now
(define (maybe-mod-objects objects)
  objects)
;;;  (let ([msg (thread-try-receive)])
;;;    (cond [msg (display "GOT MSG")]
;;;          [(and msg (eq? (car msg) 'earth)) (begin (display "GOT MSG") objects) ]
;;;          [else objects])))

(define (receive-and-exec-expr)
  (let ([msg (async-channel-try-get c)])
    (cond [msg (eval msg)])))

(define (do-tick w) (let* ([objects (dict-ref w 'objects)]
                           [rotated-objects (cons (car objects) (rotate-objects (cdr objects)))]) ; skip first object as it does not rotate
                      (dict-set! w 'objects rotated-objects)
                      (dict-set! w 'scene (compose-scene rotated-objects))
		      (dict-set! w 'objects (maybe-mod-objects rotated-objects))
                      (receive-and-exec-expr)
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


;; ==============================
(define (set-earth! new-earth)
  (set! earth new-earth)
  (dict-set! w 'objects `(,sun ,earth ,moon ,rocket)))

(define (set-earth-color! new-color)
  (let ([e (list-ref (dict-ref w 'objects) 1)])
    (vector-set! e 0 (circle 20 "solid" new-color))))


;; Example getting things running and modifying a scene object: 'earth'
;;; Approach 1:
;;; > start running per:
;;;     (start-universe)
;;; > click 'Stop' button
;;; > re-define 'earth' per:
;;;    (set-earth! (vector (circle 15 "solid" "green")   (vector 100 180)   (make-rot-matrix 0.01)))
;;;
;;; Approach 2:
;;; > start running per:
;;;    (define t (thread start-universe))
;;; > send msg with new 'earth' per:
;;;   DOES NOT SEEM TO WORK (NEVER RECEIVES msg using 'thread-try-receive')
;;; (thread-send t `(set-earth! (vector (circle 20 "solid" "green")   (vector 90 90)   (make-rot-matrix 0.01))))
;;;   USING ASYNC CHANNELS INSTEAD
;;; (async-channel-put c '(set-earth! (vector (circle 20 "solid" "green")   (vector 90 90)   (make-rot-matrix 0.01))))
;;; (async-channel-put c '(set-earth-color! "darkgreen"))
