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
     (set! stack (car (handle_f stack EXPR))) ...
     (display (car stack))))

; make 'stacker-mod-begin' available outside this module under the
; name '#%module-begin'
(provide (rename-out [stacker-mod-begin #%module-begin]))

(define (pop-stack stack)
  `(,(cdr stack) . ,(car stack)))

(define (push-stack stack arg)
  `(,(cons arg stack) . ,arg))

(define (handle [arg #f])
  arg)

(define (calc op stack)
  (define p1 (car stack))
  (define p2 (cadr stack))
  (push-stack (cddr stack ) (op p1 p2)))

(define (handle_f stack arg)
  (cond [(number? arg) (push-stack stack arg)]
        [(member arg `(,+ ,*)) (calc arg stack)]
        [else `(,stack #f)]))

(provide handle)

(provide + *)
