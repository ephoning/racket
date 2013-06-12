#lang racket

(require (planet vyzo/crypto) (planet vyzo/crypto/util) (planet vyzo/crypto/test))
;(require crypto)
;(require crypto/util)
;(require crypto/test)

(run-tests)

(define msg #"There is a cat in the box.")
(hex (sha1 msg))

(hex (md5 msg))