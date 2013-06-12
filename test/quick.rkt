#lang slideshow

(define (eddie n)
  (let ([x 42] [y 123])
    (+ x y n)))

(define (square n)
  (filled-rectangle n n))

(define (four p)
  (define two-p (hc-append p p))
  (vc-append two-p two-p))

(define (checker p1 p2)
  (let ([pl1 (hc-append p1 p2)]
        [pl2 (hc-append p2 p1)])
    (vc-append pl1 pl2)))

(checker (colorize (square 10) "red")
         (colorize (square 10) "black"))
            
(define (series f)
  (hc-append 4 (f 5) (f 10) (f 20)))

(define (rgb-series f)
  (vc-append 4
   (series (lambda (s) (colorize (f s) "red")))
   (series (lambda (s) (colorize (f s) "green")))
   (series (lambda (s) (colorize (f s) "blue")))))

(define (rainbow p)
  (map (lambda (color) (colorize p color))
       (list "red" "orange" "yellow" "green" "blue" "purple")))

(require slideshow/flash)
(filled-flash 10 20)

(provide rainbow square)
