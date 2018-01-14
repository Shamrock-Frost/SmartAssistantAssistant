#lang racket

(require syntax/parse/define (for-syntax "structs.rkt" racket racket/syntax) "structs.rkt")
(provide define/manifest define/fulfillment define/action #%module-begin #%app #%datum)

(define-syntax-parser manifest-execute
  [(_ (function:id args:expr ...) manifest)
   (define function-dat (syntax->datum #'function))
   (match function-dat
     ['require (let ([arg (first (syntax->datum #'(args ...)))])
                 #`(let ([reqs (manifest-surface-requirements manifest)])
                     (set-manifest-surface-requirements! manifest
                                                         (cons '#,arg reqs))))]
     ['sample-invocation #'(set-manifest-sample-invocation! manifest
                                                            (list args ...))]
     [else #`(#,(format-id #'here "set-manifest-~a!" function-dat) manifest (first (list args ...)))])])

(define-syntax-parser define/manifest
  [(_ name:id form:expr ...)
    #'(begin
        (define temp-manifest (manifest))
        (manifest-execute form temp-manifest) ...
        (define name temp-manifest))])

(define-syntax-parser action-execute
  [(_ (function:id args:expr ...) action)
   (define function-dat (syntax->datum #'function))
   (match function-dat
     ['require-sign-in #'(set-action-sign-in-required! action #t)]
     ['intent (syntax-parse #'(args ...)
                #:datum-literals (: trigger query-pattern)
                [(intent-name:id) #`(set-action-intent! action 'intent-name)]
                [((intent-name:id (: arg-name:id type:id) ...)
                  (trigger (query-pattern pat:string) ...))
                 #'(set-action-intent! action (intent 'intent-name
                                                      (list (list 'arg-name 'type) ...)
                                                      (list pat ...)))])]
     ['fulfillment #'(set-action-fulfillment! action (fulfillment-json-name (first (list args ...))))]
     [else #`(#,(format-id #'here "set-action-~a!" function-dat) action (first (list args ...)))])])

(define-syntax-parser define/action
  [(_ name:id json-name:string form:expr ...)
   #'(begin
       (define temp-action (action))
       (set-action-json-name! temp-action json-name)
       (action-execute form temp-action) ...
       (define name temp-action))])

(define-syntax-parser parse-headers
  [(_) #'null]
  [(_ kw:keyword arg:string rest ...)
   #'(cons (list (keyword->string 'kw) arg)
           (parse-headers rest ...))])

(define-syntax-parser fulfillment-execute
  [(_ (function args ...) fulfillment)
   (define function-dat (syntax->datum #'function))
   (if (eq? function-dat 'headers)
       #'(set-fulfillment-headers! fulfillment (parse-headers args ...))
       #`(#,(format-id #'here "set-fulfillment-~a!" function-dat) fulfillment (first (list args ...))))])

(define-syntax-parser define/fulfillment
  [(_ name:id json-name:string form:expr ...)
    #'(begin
        (define temp-fulfillment (fulfillment))
        (set-fulfillment-json-name! temp-fulfillment json-name)
        (fulfillment-execute form temp-fulfillment) ...
        (define name temp-fulfillment))])