#lang racket

(require racket/draw)

(define drawing (make-bitmap 200 100)) ; a 200x100 bitmap
(define dc (new bitmap-dc% [bitmap drawing]))

; background
(send dc set-brush (new brush% [color "yellow"]))
(send dc draw-rectangle 0 0 200 100)

; antenna
(send dc draw-line 160 5 160 50)
(send dc set-brush (new brush% [color "gray"]))
(send dc draw-rectangle 155 45 10 5)

; body
(send dc set-pen "black" 2 'solid)
(send dc set-brush (new brush% [color "gray"]))
(send dc draw-rectangle 60 20 80 30)

(send dc set-brush (new brush% [color "red"]))
(define c (make-object color% 0 255 255))
(send dc set-pen c 2 'solid)
(send dc draw-rectangle 20 50 160 30)

; wheels
(send dc set-pen "black" 2 'solid)
(send dc set-brush (new brush% [color "blue"]))
(send dc draw-ellipse  40 60 40 40)
(send dc draw-ellipse 120 60 40 40)

(send dc draw-text "This is a car?" 5 1)

(print drawing)