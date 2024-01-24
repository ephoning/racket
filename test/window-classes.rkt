#lang racket
(require racket/class racket/gui/base)

(define f (new frame% 
               [label "My Art"]
               [width 300]
               [height 300]
               [alignment '(center center)]))

(define c1 (new canvas% [parent f] [style '(border)]))
(define c2 (new canvas% [parent f] [style '(border)]))

(send f show #t)

(define b1-cb (lambda (b e) (display "pushed\n") ))
(define b1 (new button% [label "push"] [enabled #t] [min-width 30] [min-height 20] [parent f] [callback b1-cb]))

(define t1-cb (lambda (b e) (display (string-append(send b get-value) "\n") )))
(define t1 (new text-field% [label "input"] [parent f] [callback t1-cb]))
