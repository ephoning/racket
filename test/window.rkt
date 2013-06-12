#lang racket

(require racket/gui/base)
 
; Make a frame by instantiating the frame% class
;(define frame (new frame% [label "Example"]))
(define frame (new frame%
                   [label "Example"]
                   [width 300]
                   [height 300]))
 
; Make a static text message in the frame
(define msg (new message% [parent frame]
                          [label "No events so far..."]))
 
; Make a button in the frame
(new button% [parent frame]
             [label "Click Me"]
             ; Callback procedure for a button click:
             [callback (lambda (button event)
                         (send msg set-label "Button click"))])

(new button% [parent frame]
             [label "Close"]
             ; Callback procedure for a button click:
             [callback (lambda (button event)
                         (send frame show #f))])

(new canvas% [parent frame]
             [paint-callback
              (lambda (canvas dc)
                (send dc set-scale 3 3)
                (send dc set-text-foreground "blue")
                (send dc draw-text "Don't Panic!" 0 0))])

; Show the frame by calling its show method
(send frame show #t)
