#lang br/quicklang


;; ====== reader ======

;; we have to name our reader's main function 'read-syntax'
;; 
(define (read-syntax path port)
  ;; aux testing (see: stacker-test-aux.rkt)
  ;;(dummy-read-syntax path port)

  ;; partial test
  ;;(partial-stacker-read-syntax path port)

  ;; finally
  (stacker-read-syntax path port)
)

(define (stacker-read-syntax path port)
  ;; get src/input lines
  (define src-lines (port->lines port))
  ;; construct datums from each of the raw src/input lines
  (define src-datums (format-datums '(handle ~a) src-lines))
  ;; construct module named 'stacker-mod', populating it with the the datums
  ;; (note the use of ,@ to unquote-splice list elements into the quasiquoted module expression)
  ;; (the expander to be found in 'stacker.rkt' stll needs defining here...)
  (define module-datum `(module stacker-mod "stacker.rkt" ,@src-datums))
  ;; convert/"upgrade" the datum to a syntax object
  ;; (note: no need to provide "program context" => use '#f' instead
  (datum->syntax #f module-datum)  
)

(define (partial-stacker-read-syntax path port)
  ;; get src/input lines
  (define src-lines (port->lines port))
  ;; construct datums from each of the raw src/input lines
  ;; (notice bould quote to keep datums as data instead of 'handle' func calls
  (define src-datums (format-datums ''(handle ~a) src-lines))
  ;; construct module named 'stacker-mod', populating it with the the datums
  ;; (note the use of ,@ to unquote-splice list elements into the quasiquoted module expression)
  ;; (the expander to be found in 'stacker.rkt' stll needs defining here...)  
  (define module-datum `(module stacker-mod br ,@src-datums))
  ;; note yet: (no epxander yet)  
  ;;(define module-datum `(module stacker-mod "stacker.rkt" ,@src-datums))
  ;; convert/"upgrade" the datum to a syntax object
  ;; (note: no need to provide "program context" => use '#f' instead
  (datum->syntax #f module-datum)  
)

;; a quick dummy test (ignores actual input received on port)
(define (dummy-read-syntax path port)
  ;; we HAVE to consume all input even though we ignore it (WHY?)
  (define src-lies (port->lines port))
  (datum->syntax #f '(module lucy br 42))  
)

;; export the 'read'syntax' function so its available outside this file
(provide read-syntax)


;; ====== expander ======

(define-macro (stacker-module-begin HANDLE-EXPR ...)
  ;; #' makes code into a datum, then into a syntax object
  #'(#%module-begin
     'HANDLE-EXPR ...))

(provide (rename-out [stacker-module-begin #%module-begin]))
