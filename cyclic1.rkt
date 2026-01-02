#lang racket

;; this require mutable pairs/list
(require racket/mpair)
(require loop)

(define cyclic (mlist 1 2 3))
(set-mcdr! (mcdr (mcdr cyclic)) cyclic)

;; extracting an arbitrary number of elements from the circular
;; multable list
(define (mtake l n) 
  (loop go ([n n] [c cyclic] [l '()])
        (cond [(> n 0) (go (sub1 n) (mcdr c) (cons (mcar c) l))]
              [(= n 0) (reverse l)])))
