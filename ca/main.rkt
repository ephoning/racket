#lang racket

;; main file for ca life experiment
;;
;; dependencies
;; - model: lens-grid based state representation
;; - view: graphics for 2d visualixation
;; - control: - driver/main loop

(require "model.rkt" "view.rkt", "control.rkt")

(define my-grid (ca-create-lens-grid 5 5))

(fill-grid my-grid 42)
