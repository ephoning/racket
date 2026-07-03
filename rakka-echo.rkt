#lang racket
(require rakka)

(start-runtime!)

;; Spawn an actor that echoes messages
(define echo (spawn (lambda ()
                      (define msg (receive))
                      (printf "Got: ~v~n" msg))))

;; Send it a message
(send! echo 'hello)
;; Output: Got: 'hello