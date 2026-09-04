#lang racket

;; Purpose: a hash based data structure to represent cells for a 2-D cellular automaton
;;
;; structure:
;; 'general -> <some hash table>   ;; <- allows storing arbitrary info applicable across the entire grid
;; 'grid -> has table with following structure:
;;          (x y) -> <some hash table>       ;; <- allows storing arbitrary info for a collection of x/y coordinates

(require lens/common)
(require lens/data/hash)

(provide ca-create-world fill-grid get-world-xsize get-world-ysize ca-grid-at)

;; generate random true/false
;;  perc [0-100] = precentage true
(define (random-t-f perc)
  (let ([r (random 0 100)])
    (<= r perc)))

; returns hash instance
(define (ca-create-world xsize ysize)
  (hash 'general (hash 'xsize xsize 'ysize ysize) 'grid (hash)))

; returns new/mutated ca-grid
(define (ca-add-cell ca-grid x y payload)
  (define ca-grid-xy-lens (hash-ref-nested-lens 'grid `(,x ,y)))
  (lens-set ca-grid-xy-lens ca-grid payload))

(define ca-xsize-lens (hash-ref-nested-lens 'general 'xsize))
(define ca-ysize-lens (hash-ref-nested-lens 'general 'ysize))
(define ca-grid-lens (hash-ref-lens 'grid))

(define (get-world-xsize world)
   (lens-view ca-xsize-lens world))
(define (get-world-ysize world)
   (lens-view ca-ysize-lens world))

;; fill the grid with cells randomly alive with probability 'alive-prob'
(define (fill-grid world alive-prob)
  (define (_fill_ world xy-pairs)
    (if (empty? xy-pairs) world
        (let ([x (caar xy-pairs)]
              [y (cadar xy-pairs)])
          (_fill_ (ca-add-cell world x y (random-t-f alive-prob)) (cdr xy-pairs)))))
  (let* ([xsize (lens-view ca-xsize-lens world)]
         [ysize (lens-view ca-ysize-lens world)]
         [xy-pairs (cartesian-product (stream->list (in-range 0 xsize)) (stream->list (in-range 0 ysize)))])
    ;(printf "~a / ~a / ~a" xsize ysize xy-pairs)
    (_fill_ world xy-pairs)))

;; extract 'state' at (x,y)
(define (ca-grid-at world x y)
  (lens-view (hash-ref-lens `(,x ,y)) (lens-view ca-grid-lens world)))

; implements 'life' rulesc (torus-shaped world is assumed)
(define (calc_new_state world x y state)
  'TODO)

; returns an evolved world
(define (ca-evolve world)
  (define (_evolve_ world xy-pairs)
    (if (empty? xy-pairs) world
        (let* ([xy-pair (car xy-pairs)]
               [x (car xy-pair)]
               [y (cadr xy-pair)]
               [state (ca-grid-at world x y)]
               [new-state (calc_new_state world x y state)])
          (_evolve_ (ca-add-cell world x y new-state) (cdr xy-pairs)))))
  (let* ([xsize (get-world-xsize world)]
        [ysize (get-world-ysize world)]
        [xy-pairs (cartesian-product (stream->list (in-range 0 xsize)) (stream->list (in-range 0 ysize)))])
    (_evolve_ world xy-pairs)))

;; TESTING

#|

(define my-world (ca-create-world 10 10))
(define my-updated-world (ca-add-cell my-world 3 3 (hash 'alive #t)))

(fill-grid my-world 42)

; access x/y values example
(define g (fill-grid my-world 50))
; access 'state' at (8,7) without using lens
(hash-ref (hash-ref g 'grid) '(8 7))
; access 'state at (8,7) using lens
(lens-view (hash-ref-lens '(8 7)) (lens-view ca-grid-lens g))

#|
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
|#

(cartesian-product (stream->list (in-range 0 2)) (stream->list (in-range 0 3)))

(for ([x (in-range 0 2)])
  (for ([y (in-range 0 3)])
    (printf "~a / ~a\n" x y)))
|#
