#lang racket

(require racket/flonum)

(define (mandelbrot iterations x y n)
  (let ([ci (fl- (fl/ (* 2.0 (->fl y)) (->fl n)) 1.0)]
        [cr (fl- (fl/ (* 2.0 (->fl x)) (->fl n)) 1.5)])
    (let loop ([i 0] [zr 0.0] [zi 0.0])
      (if (> i iterations)
          i
          (let ([zrq (fl* zr zr)]
                [ziq (fl* zi zi)])
            (cond
              [(fl> (fl+ zrq ziq) 4.0) i]
              [else (loop (add1 i)
                          (fl+ (fl- zrq ziq) cr)
                          (fl+ (fl* 2.0 (fl* zr zi)) ci))]))))))



(mandelbrot 100000000 62 500 10000000)1

;(require future-visualizer)
;(visualize-futures
; (let ([f (future (lambda () (mandelbrot 1000 62 501 1000)))])
;   (list (mandelbrot 1000 62 500 1000)
;         (touch f))))
