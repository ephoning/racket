#lang racket

; (require lazy/list)

(define sort
  (λ (l)
    (if (empty? l) '()
        (let* ([ltp? (λ (x) (< x (car l)))]
               [gtep? (λ (x) (not (ltp? x)))])
          (append
           (sort (filter ltp? (cdr l)))
           `(,(car l))
           (sort (filter gtep? (cdr l))))))))
