#lang racket

(require 2htdp/universe)
(require 2htdp/image)

(define (create-UFO-scene height)
  (underlay/xy (rectangle 100 100 "solid" "white") 50 height UFO))
 
(define UFO
  (underlay/align "center"
                  "center"
                  (circle 10 "solid" "green")
                  (rectangle 40 4 "solid" "green")))
 
(animate create-UFO-scene)
