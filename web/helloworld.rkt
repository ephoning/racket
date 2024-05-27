#lang racket
(require web-server/servlet
         web-server/servlet-env)
 
(define (start req)
  (response/xexpr
   `(html (head (title "Hello world!"))
          (body (p "Hi There!")))))
 
(serve/servlet start
               #:listen-ip #f
               #:servlet-path "/hello.rkt"
               #:launch-browser? #f)
