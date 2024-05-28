#lang racket

(require minikanren)

(run* (q) (== 1 1))

;; functional list append:
(define (append a b)
  (cond
    [(null? a) b]
    [else (cons (car a) (append (cdr a) b))]))

;; relational list append:
(define (appendo a b c)
  (conde
   ((== '() a) (== b c))
   ((fresh (d e res)
           (== `(,d . ,e) a)
           (== `(,d . ,res) c)
           (appendo e b res)))))

;; examples using relational append:
(run* (c) (appendo '(1 2 3) '(4 5 6) c))

(run* (c) (appendo '(1 2 3) c '(1 2 3 4)))

(run* (q) (fresh (a b)
                 (appendo a b '(1 2 3 4))
                 (== q (cons a `(,b)))))
