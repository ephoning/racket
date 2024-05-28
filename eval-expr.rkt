#lang racket

(define eval-expr
  (lambda (expr env)
    (match exp
      [,x (guard (symbol? x))
          (env x)]
      [(lambda (,x) ,body)
       (lambda (arg)
         (eval-expr body (lambda (y)
                           (if (eq? x y)
                               arg
                               (env y)))))]
      [(,rator ,rand)
       ((eval-expr rator env)
        (eval-expr rand env))])))
