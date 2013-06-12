#lang racket


(define ccc #f)

(define go1
  (λ ()
    (begin
      (display "at the start\n")
      (call/cc
       (λ (k)
         (begin
           (set! ccc k)
           (display "at the middle\n"))))
      (display "at the end\n"))))

; -----------------------

(define go2
  (λ ()
    (begin
      (display "at the start\n")
      (call/cc (λ (k) (set! ccc k)))
      (display "at the end\n"))))

; -----------------------

(define _go3
  (λ ()
      (display "at the start\n")
      (call/cc (λ (k) (set! ccc k) -1))))

(define go3-old
  (λ () 
    (_go3) ; note: the continuation does NOT take an arg
    42))

(define go3
  (λ (x) 
    (_go3)
    (display (list 'go3 x))
    123))

(define top1
  (λ (x) (display (list "result:" x))))

(top1 (go3 42))

(top1 (_go3)) ; note: the continuation from the perspective on '_go3' is a proc that takes one arg - this proc is 'top1')=> (ccc 42) -> (result: 42)

(define top2
  (λ (x y) (+ x y)))

(top2 (_go3) 123)

(ccc 5)
(ccc 6)
(ccc 7) ; note that that values passed to 'ccc' are what fills the 'hole' in the (_go3) slot in top2, as 'ccc' is the continuation of _go3 in (top2 (_go3) 123), which is (top2 [] 123]))
