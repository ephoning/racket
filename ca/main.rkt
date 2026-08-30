#lang racket

;; main file for ca life experiment
;;
;; dependencies
;; - lens-grid: model - state representation
;; - display:   view - graphics for 2d visualixation
;; - this file: control - driver/main loop

(require "lens-grid.rkt")

(define my-grid (ca-create-lens-grid 5 5))

(fill-grid my-grid 42)
