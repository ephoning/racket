#lang racket

(require 2htdp/image)
(require global)


(define plt-logo-1 "/Users/ephoning/Pictures/plt-logo-red-diffuse.png")                       
(define plt-logo-2 "/Users/ephoning/Pictures/plt-logo-red-shiny.png")

(define-global *state*
  (bitmap/file plt-logo-1)
  "global state"
  string?
  bitmap/file)


(printf "Current state: ~a\n" *state*)


(*state*)

(*state* plt-logo-2)

(*state*)
