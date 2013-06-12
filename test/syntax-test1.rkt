#lang racket

(define-syntax s1
  (syntax-rules ()
      ((_ e1 ...) (list e1 ...))))  

; note: ellipses match 0 or more instances (i.e., there might not even be an 'e1'...)
; valid uses of s1:
; (s1)
; (s1 42)
; (s1 'a 'b) etc.
