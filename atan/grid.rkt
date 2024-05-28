#lang racket

(require 2htdp/image)

;; construct projection function
(define (make-projection zoom scale)
  (let ((m (* (/ 1 pi) 2 scale)))
    (lambda (x) (* (atan (* x zoom)) m))))

;; construct tuple projection function
(define (make-pair-projection projection-lambda)
  (lambda (xy)
  `(,(projection-lambda (car xy))
    ,(projection-lambda (cadr xy)))))
    
(define (corners size)
  `(,`(,size ,size) ,`(,(- size) ,size) ,`(,(- size) ,(- size)) ,`(,size ,(- size)))) 
          
(define (cross x-orig y-orig size)
  `(,`(,x-orig ,y-orig) 
    ,`(,(+ x-orig size) ,y-orig) ,`(,x-orig ,(+ y-orig size)) ,`(,(- x-orig size) ,y-orig) ,`(,x-orig ,(- y-orig size))))
  
;; construct list of (x,y) tuples, laid out in a grid
;; make sure 'size' is a power of 2
(define (grid size unit)
    (append (corners size) (_grid 0 0 size unit)))

(define (_grid x-orig y-orig size unit)
  (cond ((< size unit) 
         '())
        (true
         (let ((new-size (/ size 2)))
           (append (cross x-orig y-orig size)
                   (_grid (+ x-orig new-size) (+ y-orig new-size) new-size unit)
                   (_grid (- x-orig new-size) (+ y-orig new-size) new-size unit)
                   (_grid (- x-orig new-size) (- y-orig new-size) new-size unit)
                   (_grid (+ x-orig new-size) (- y-orig new-size) new-size unit))))))

;; translate a coordinate pair
(define (translate xy xyoffset)
  `(,(+ (car xy) (car xyoffset)) ,(+ (cadr xy) (cadr xyoffset))))

;; a 'point' line to draw with a pen
(define (point xy)
  `(,(car xy) ,(cadr xy) ,(car xy) ,(cadr xy)))

;; -> image            
(define (go size count zoom)
  (let* ((img (rectangle size size "solid" "black"))
        (pen (make-pen "white" 2 "solid" "round" "round"))
        (xys (grid count 1))
        (hsize (/ size 2))
        (xform (make-pair-projection (make-projection zoom hsize))))
    (composeImg img pen hsize xys zoom xform)))

(define (composeImg img pen hsize xys zoom xform)
  (cond ((null? xys) 
         img)
        (true
         (let* ((dot (translate (xform (car xys)) `(,hsize ,hsize)))
                (x (car dot))
                (y (cadr dot)))
         (composeImg (add-line img x y x y pen) pen hsize (cdr xys) zoom xform)))))
