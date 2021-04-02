#lang br/quicklang

(define (read-syntax path port)
  (define src-lines (port->lines port))
  (define src-datums (format-datums '(handle ~a) src-lines))
  (datum->syntax #f `(module stacker-mod "stacker.rkt" ,@src-datums)))

(provide read-syntax)

; '#'X' is short for '(datum->syntax X)' and also captures lexical ctxt
(define-macro (stacker-mod-begin EXPR ...)
  #'(#%module-begin
     EXPR ...
     (display (first stack))))

; make 'stacker-mod-begin' available outside this module under the
; name '#%module-begin'
(provide (rename-out [stacker-mod-begin #%module-begin]))

(define stack empty)

(define (pop-stack!)
  (define arg (first stack))
  (set! stack (rest stack))
  arg)

(define (push-stack! arg)
  (set! stack (cons arg stack)))

(define (handle [arg #f])    ; note: #f is default value for 'arg'
  (cond
    [(number? arg) (push-stack! arg)]
    [(or (equal? + arg) (equal? * arg))
     (define op-result (arg (pop-stack!) (pop-stack!)))
     (push-stack! op-result)]))

(provide handle)

(provide + *)
