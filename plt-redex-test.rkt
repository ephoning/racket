#lang racket

; see, for example: https://dvanhorn.github.io/redex-aam-tutorial/

(require redex)

(define-language L
  (M ::= N F (M ...))  ; postfix '...' means 0 or more repetitions of the preceding pattern
  (F ::= foo bar)
  (N ::= 123 42))

(redex-match? L F (term foo))  ; #t
(redex-match? L (M ...) (term (foo 42 bar 123)))  ; #t

(redex-match? L (M M) (term (foo (123 bar)))) ; #f
(redex-match? L (M_1 M_2) (term (foo (123 bar)))) ; #t

(redex-match? L foo (term foo))  ; #t

(define-metafunction L swap : M -> M
  [(swap foo) bar]
  [(swap bar) foo]
  [(swap (M ...)) ((swap M) ...)]  ; distributes 'swap' call to all list elements
  [(swap M) M])

(term (swap foo))  ; 'bar
(term (swap (foo 42 bar)))  ; '(bar 42 foo)