#lang racket

;; main file for ca life experiment
;;
;; dependencies
;; - model: lens-grid based state representation
;; - view: graphics for 2d visualixation
;; - control: - driver/main loop

(require "model.rkt" "view.rkt" "control.rkt")

(define xsize 40)
(define ysize 40)
(define alive-prob 40) ; 'alive' cell density at 30% 
(define cell-display-size 15)

(define my-empty-world (ca-create-world xsize ysize))
(define my-world (fill-grid my-empty-world alive-prob))

(define my-viewport (view-start (* xsize cell-display-size) (* ysize cell-display-size)))
(draw-world my-viewport my-world cell-display-size)

;(sleep 15)

;(view-end my-viewport)

