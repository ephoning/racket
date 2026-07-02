#lang racket

(define eval-expr
  (λ (expr env)
    (pmatch expr
            [,x (guard (symbol? x))
                (env x)]
            [(λ ,x ,body)
             (λ (arg)
               (eval-expr body (λ (y)
                                 (if (eq x y)
                                     arg
                                     (env y)))))]            
             [(,rator ,rand)
              ((eval-expr rator env)
               (eval-expr rand env))]
             )))


(eval-expr '(add1 (add1 5)) (λ (y) (error 'lookup 'unbound)))