#lang racket

(require "f1-module.rkt")

(define f2
  (lambda (x) (* (f1 x) (f1 x))))

(f2 7)
