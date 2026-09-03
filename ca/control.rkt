#lang racket

;; main file for ca life experiment
;;
;; dependencies
;; - model: lens-grid based state representation
;; - view: graphics for 2d visualixation
;; - this file: control - driver/main loop

(require "model.rkt" "view.rkt")

(define my-world (ca-create-world 5 5))

(fill-grid my-world 42)
