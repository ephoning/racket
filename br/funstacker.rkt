#lang br/quicklang

(define (read-syntax path port)
  (define src-lines (port->lines port))
  (define src-datums (format-datums '(handle ~a) src-lines))
  ; path to rkt module indicates where the expander for the syntax datums
  ; is to be found - i.e., the impllementation of '#%module-begin'
  (datum->syntax #f `(module stacker-mod "funstacker.rkt" ,@src-datums)))

(provide read-syntax)

; '#'X' is short for '(datum->syntax X)' and also captures lexical ctxt
(define-macro (stacker-mod-begin EXPR ...)
  #'(#%module-begin
     (define stack empty)
     (handle_f (cadr 'EXPR)) ...
     (display (car stack))))

; make 'stacker-mod-begin' available outside this module under the
; name '#%module-begin'
(provide (rename-out [stacker-mod-begin #%module-begin]))

(define (pop-stack stack)
  (define arg (first stack))
  (set! stack (rest stack))
  arg)

(define (push-stack stack arg)
  (set! stack (cons arg stack)))

(define (handle_f stack [arg #f]) ; note: #f is default value for 'arg'
  (cond [(number? arg) (push-stack stack arg)]
        [(member arg `(,+ ,*)) (push-stack stack (arg (pop-stack stack) (pop-stack stack)))]))

(provide handle_f)

(provide + *)
