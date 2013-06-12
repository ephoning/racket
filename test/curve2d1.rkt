#lang racket

(require 2htdp/image)
 
(add-curve
   (add-curve
    (rectangle 40 100 "solid" "black")
    20 10 180 1/2
    20 90 180 1/4
    (make-pen "white" 4 "solid" "round" "round"))
   20 10 0 1/2
   20 90 0 1/2
   (make-pen "green" 4 "solid" "round" "round"))