#lang racket

(require lens/common)
(require lens/data/hash)

;; mutable has table; not suited to target in lenses
(define d-top (make-hash))
(define d-sub (make-hash))
(dict-set! d-top 'foo 42)
(dict-set! d-sub 'fi 1)
(dict-set! d-sub 'fa 2)
(dict-set! d-sub 'fo 3)
(dict-set! d-top 'sub d-sub)

(displayln d-top)
(displayln (immutable? d-top))

;; immutable hash table; suitable for use in lenses
(define d (hash 'foo 42 'sub (hash 'fi 1 'fa 2 'fo 3)))

(define foo-lens (hash-ref-lens 'foo))
(define sub-fi-lens (hash-ref-nested-lens 'sub 'fi))

(displayln d)
(displayln (immutable? d))
(define d-mod (lens-set sub-fi-lens d 123))
(displayln d-mod)
(displayln (immutable? d-mod))
