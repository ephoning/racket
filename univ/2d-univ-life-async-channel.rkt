#lang racket


(require 2htdp/universe 2htdp/image racket/async-channel) 

(define backdrop (empty-scene 400 400 "white"))
; objects: (<shape> <abs/rel pos> <rotation matrix>)
(define earth  (vector (line 150 200 "blue")   (vector 200 200)   ))
(define moon   (vector (circle 5 "solid" "white")   (vector 30 30)  ))
(define rocket (vector (circle 20 "solid" "red")     (vector 0 0)  ))

(define (extract-element objects idx) (cond [(empty? objects) '()]
                                            [else (cons (vector-ref (car objects) idx) (extract-element (cdr objects) idx))]))
(define (extract-images objects) (extract-element objects 0))
(define (extract-poss objects) (extract-element objects 1))

(define w (make-hash))

(define c (make-async-channel))

(define (compose-images images poss accu)
  (cond [(empty? images) accu]
        [else (let ([image (car images)]
                    [pos (car poss)])
                (compose-images (cdr images) (cdr poss) (place-image image (vector-ref pos 0)
                                                                     (vector-ref pos 1) accu)))]))

(define (compose-scene objects)
    (compose-images (extract-images objects) (extract-poss objects) backdrop))

(define (compose-scene-grid)
  (add-line (add-line (add-line backdrop 0 0 0 400 "black") 20 0 20 400 "black") 40 0 40 400 "black"))

(define (start)
  (dict-set! w 'end? #false)
  (dict-set! w 'objects `(,earth ,moon ,rocket))
  ;(dict-set! w 'scene (compose-scene (dict-ref w 'objects)))
  (dict-set! w 'scene backdrop)
  w)

(define (update-objects objects) objects) ;  NO-OP FOR NOW

;; a no-op for now
(define (maybe-mod-objects objects)
  objects)

(define (receive-and-exec-expr)
  (let ([msg (async-channel-try-get c)])
    (cond [msg (eval msg)])))

(define (do-tick w) (let* ([objects (dict-ref w 'objects)]
                           [updated-objects (update-objects objects)])
                      (dict-set! w 'objects updated-objects)
                      ;(dict-set! w 'scene (compose-scene updated-objects))
                      (dict-set! w 'scene (compose-scene-grid))
		      (dict-set! w 'objects (maybe-mod-objects updated-objects))
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
  (dict-set! w 'objects `(,earth ,moon ,rocket)))

(define (set-earth-color! new-color)
  (let ([e (list-ref (dict-ref w 'objects) 1)])
    (vector-set! e 0 (circle 20 "solid" new-color))))

;; TODO provide means to modify properties of objects as embedded in the world 'w'


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
