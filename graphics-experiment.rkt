#lang racket

(require graphics/graphics)

(open-graphics)
; nothing appears to happen, but the library is initialized...
 
(define w (open-viewport "practice" 300 300))
; viewport window appears
 
((draw-line w) (make-posn 30 30) (make-posn 100 100))
; line appears
 
;(close-viewport w)
; viewport disappears
 
;(close-graphics)
; again, nothing appears to happen, but
; unclosed viewports (if any) would disappear