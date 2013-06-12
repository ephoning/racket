#lang racket

(require (planet vyzo/crypto) (planet vyzo/crypto/util))

;(require vyzo/crypto)

 
(define msg #"There is a cat in the box.")
(hex (sha1 msg))

(hex (md5 msg))
