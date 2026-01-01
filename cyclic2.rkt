; Source - https://stackoverflow.com/a/28376063
; Posted by Sylwester
; Retrieved 2025-12-31, License - CC BY-SA 3.0

#!racket

(require srfi/1)
(circular-list 1 2 3) ; ==> #0=(1 2 3 . #0#)

;; alternatively you can make a list circular
(apply circular-list '(1 2 3)) ; ==> #0=(1 2 3 . #0#)

(map cons '(1 2 3 4 5 6) (circular-list #t)) 
; ==> ((1 . #t) (2 . #t) (3 . #t) (4 . #t) (5 . #t) (6 . #t))
