#lang racket

(require graphics/graphics)

(open-graphics)
; nothing appears to happen, but the library is initialized...
 
;(define w (open-viewport "practice" 300 300))
; viewport window appears
 
;;((draw-line w) (make-posn 30 30) (make-posn 100 100))
;;((draw-line w) (make-posn 40 40) (make-posn 80 100))
;;
;;(sleep 1)
;;
;;((clear-viewport w))
;;((draw-line w) (make-posn 30 30) (make-posn 100 110))
;;((draw-line w) (make-posn 40 40) (make-posn 80 110))


; line appears
 
;(close-viewport w)
; viewport disappears
 
;(close-graphics)
; again, nothing appears to happen, but
; unclosed viewports (if any) would disappear


(define (draw-grid w h-cnt v-cnt size)
  (let ([v-lines-x0s (range 0 (* h-cnt size) size)]
        [v-lines-x1s (range 0 (* h-cnt size) size)]
        [v-lines-y0s (make-list h-cnt 0)]
        [v-lines-y1s (make-list h-cnt (* h-cnt size))]
        [h-lines-x0s (make-list v-cnt 0)]
        [h-lines-x1s (make-list v-cnt (* v-cnt size))]
        [h-lines-y0s (range 0 (* v-cnt size) size)]
        [h-lines-y1s (range 0 (* v-cnt size) size)])
    (for ([i (range 0 h-cnt)])
      ((draw-line w) (make-posn (list-ref v-lines-x0s i)
                                (list-ref v-lines-y0s i))
                     (make-posn (list-ref v-lines-x1s i)
                                (list-ref v-lines-y1s i))))
    (for ([i (range 0 v-cnt)])
      ((draw-line w) (make-posn (list-ref h-lines-x0s i)
                                (list-ref h-lines-y0s i))
                     (make-posn (list-ref h-lines-x1s i)
                                (list-ref h-lines-y1s i))))))

; logical locations on a 2-D grid
; each 'locus' is defined by
; - x/y (coordinate) labels
; - a properties list
; to create loci, specify:
; - number of loci in x dimension
; - number of loci in y dimension
; - a function to associate a properties instance with each loci
;   this function is invoked with x and y coordinate values
(define (grid-loci h-cnt v-cnt props-setter)
  (for*/list ([x (range 0 h-cnt)]
              [y (range 0 v-cnt)])
    (list x y (props-setter x y))))

; example prop setter
(define (default-prop x y)
  `(,x ,y ,(if (= (random 2) 1) 'alive 'dead)))


; side-effect only display/drawing of loci
; params:
; - loci: list of loci
; - draw: draw function specific to display framework used
;         each call is to handle a single locus from the list of loci
(define (draw-loci loci draw)
  (for ([locus loci])
    (draw locus)))

; TODO graphics/graphics based locus visualization
(define (draw-graphics locus)
  (let ([x (list-ref locus 0)]
        [y (list-ref locus 1)]
        [state (list-ref (list-ref locus 2) 2)])
    ((draw-solid-ellipse w2) (make-posn (+ 2 (* x 8)) (+ 2 (* y 8))) 8 8 (if (eq? state 'alive) "black" "white"))))



; a second viewport
(define w2 (open-viewport "grid" 300 300))

; draw some loci
(define loci (grid-loci 40 40 default-prop))
(draw-loci loci draw-graphics)


;(draw-grid w2 40 40 10)

(sleep 10)

(close-viewport w2)
; viewport disappears
 
(close-graphics)
; again, nothing appears to happen, but
; unclosed viewports (if any) would disappear
