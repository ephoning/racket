#lang racket

(require graphics/graphics)

(open-graphics)
; nothing appears to happen, but the library is initialized...
 
(define w (open-viewport "practice" 300 300))
; viewport window appears
 
((draw-line w) (make-posn 30 30) (make-posn 100 100))
((draw-line w) (make-posn 40 40) (make-posn 80 100))

(sleep 1)

((clear-viewport w))

((draw-line w) (make-posn 30 30) (make-posn 100 110))
((draw-line w) (make-posn 40 40) (make-posn 80 110))


; line appears
 
;(close-viewport w)
; viewport disappears
 
;(close-graphics)
; again, nothing appears to happen, but
; unclosed viewports (if any) would disappear


; a second viewport
(define w2 (open-viewport "practice" 300 300))

(for ([i
       (range 0 200 10)])
  ((draw-line w2) (make-posn 30 30) (make-posn (+ i 10) (+ i 100)))
  (sleep 1)
  )

(close-viewport w)
; viewport disappears
 
(close-graphics)
; again, nothing appears to happen, but
; unclosed viewports (if any) would disappear
