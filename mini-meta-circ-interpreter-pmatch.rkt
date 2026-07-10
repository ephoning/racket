#lang scheme

(load "//Users/ephoning/projects/racket-public/match/match.sc")

(define eval-expr
  (λ (expr env)
    (match expr
      (n
       (number? n)
       n)
      (x
       #:when (symbol? x)
       (env x))
      ((list plus a b)
       (+ a b))
      ((list lamb (list x) body)
       (λ (arg)
         (eval-expr body (λ (y)
                          (if (eq? x y)
                              arg
                              (env y))))))
      ((list rator rand)
       ((eval-expr rator env)
        (eval-expr rand env))))))

(define id-env (λ (x) x))
