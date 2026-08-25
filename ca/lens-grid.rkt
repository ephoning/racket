#lang racket

;; Purpose: a hash based data structure to represent cells for a 2-D cellular automaton
;;
;; structure:
;; 'general -> <some hash table>   ;; <- allows storing arbitrary info applicable across the entire grid
;; 'grid -> has table with following structure:
;;          (x y) -> <some hash table>       ;; <- allows storing arbitrary info for a collection of x/y coordinates

(require lens/common)
(require lens/data/hash)


(define (ca-create-lens-grid xsize ysize)
  (hash 'general (hash 'xsize xsize 'ysize ysize) 'grid (hash)))

(define (ca-add-cell ca-grid x y payload)
  (define ca-grid-xy-lens (hash-ref-nested-lens 'grid `(,x ,y)))
  (lens-set ca-grid-xy-lens ca-grid payload))


;; immutable hash table; suitable for use in lenses
(define d (hash 'foo 42 'sub (hash 'fi 1 'fa 2 'fo 3)))

(define foo-lens (hash-ref-lens 'foo))
(define sub-fi-lens (hash-ref-nested-lens 'sub 'fi))
(define sub-foobar-lens (hash-ref-nested-lens 'sub 'foobar))

(displayln d)
(displayln (immutable? d))
(define d_ (lens-set sub-fi-lens d 123)) ;; "mutate" existing field
(displayln d_)
(displayln (immutable? d_))
(define d__ (lens-set sub-foobar-lens d_ 17)) ;; add new field
(displayln d__)
(displayln (immutable? d__))

(display (lens-view (hash-ref-nested-lens 'sub 'foobar) d__))
