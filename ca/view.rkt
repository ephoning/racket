#lang racket

(require graphics/graphics)
(require "model.rkt")

(provide view-start view-end)

(define (view-start xsize ysize)
  (open-graphics)
  (open-viewport "CA" xsize ysize))

(define (view-end viewport)
  (close-viewport viewport) 
  (close-graphics)) ;; unclosed viewports - if any - are close as well

(define (draw-world viewport world)
  (let* ([xsize (get-world-xsize world)]
        [ysize (get-world-ysize world)]
        [xy-pairs (cartesian-product (stream->list (in-range 0 xsize)) (stream->list (in-range 0 ysize)))])
    42))

; graphics/graphics based locus visualization
(define (draw-graphics viewport locus)
  (let ([x (list-ref locus 0)]
        [y (list-ref locus 1)]
        [state (list-ref (list-ref locus 2) 2)])
    ((draw-solid-ellipse viewport) (make-posn (+ 2 (* x 8)) (+ 2 (* y 8))) 8 8 (if (eq? state 'alive) "black" "white"))))

; side-effect only display/drawing of loci
; params:
; - loci: list of loci
; - draw: draw function specific to display framework used
;         each call is to handle a single locus from the list of loci
(define (draw-loci viewport loci draw)
  (for ([locus loci])
    (draw viewport locus)))

(define (draw-raster viewport h-cnt v-cnt size)
  (let ([v-lines-x0s (range 0 (* h-cnt size) size)]
        [v-lines-x1s (range 0 (* h-cnt size) size)]
        [v-lines-y0s (make-list h-cnt 0)]
        [v-lines-y1s (make-list h-cnt (* h-cnt size))]
        [h-lines-x0s (make-list v-cnt 0)]
        [h-lines-x1s (make-list v-cnt (* v-cnt size))]
        [h-lines-y0s (range 0 (* v-cnt size) size)]
        [h-lines-y1s (range 0 (* v-cnt size) size)])
    (for ([i (range 0 h-cnt)])
      ((draw-line viewport) (make-posn (list-ref v-lines-x0s i)
                                       (list-ref v-lines-y0s i))
                            (make-posn (list-ref v-lines-x1s i)
                                       (list-ref v-lines-y1s i))))
    (for ([i (range 0 v-cnt)])
      ((draw-line viewport) (make-posn (list-ref h-lines-x0s i)
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



; draw some loci
(define (testrun)
  (define vp1 (view-start 100 100))
  (define loci (grid-loci 10 10 default-prop))
  (draw-loci vp1 loci draw-graphics)
  (sleep 5)
  (view-end vp1))

