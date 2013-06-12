#lang racket

;replicating clojure's shorthand lambda
(define rt (make-readtable #f #\# 'non-terminating-macro
                           (λ (c in . _)
                             (define body (read in))
                             `(lambda (%) ,body))))
(parameterize ([current-readtable rt]
               [current-namespace (make-base-namespace)])

  (eval (read (open-input-string "(#(+ 1 %) 5)")))) ;; => 6

;#lang racket
;Here's how to implement your simpler example, making & be equivalent to ':

(define rt2 (make-readtable #f #\& #\' #f))

(parameterize ([current-readtable rt2]
               [current-namespace (make-base-namespace)])
  (eval (read (open-input-string "&(3 4 5)")))) ;; => '(3 4 5)