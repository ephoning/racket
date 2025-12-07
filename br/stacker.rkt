#lang br/quicklang


;; ====== reader ======

;; we have to name our reader's main function 'read-syntax'
;; 
(define (read-syntax path port)
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
  ;; note that this means that the body of this implementation is to
  ;; contain regular (i.e., not quoted) code
  ;;
  ;; Racket identifers starting with the prefix #% are special
  ;; core syntactic forms used internally by the macro expander and compiler
  #'(#%module-begin
     HANDLE-EXPR ...
     (car stack)))

(provide (rename-out [stacker-module-begin #%module-begin]))

;; ====== actual 'handle' internals ======

(define stack empty)

(define (pop-stack!)
  (define v (car stack))
  (set! stack (cdr stack))
  v)

(define (push-stack! v)
  (set! stack (cons v stack)))

;; (arg has default value of #f)
(define (handle [arg #f])
  (cond [(number? arg) (push-stack! arg)]
        [(member arg `(,+ ,*)) (push-stack! (arg (pop-stack!) (pop-stack!)))]))

;; 'provide is needed to make it available outside this source file
(provide handle)
;; this also goes for the operator; we get them from the br module
(provide + *)
