#lang racket

(require syntax/parse/define (for-syntax "structs.rkt" racket racket/syntax) "structs.rkt")
(provide #%app #%datum define/manifest define/fulfillment (struct-out manifest) (struct-out fulfillment)
         (rename-out [saa-module-begin #%module-begin]))

(define-syntax-parser manifest-execute
  [(_ (function args ...) manifest)
   (define function-dat (syntax->datum #'function))
   (match function-dat
     ['require (let ([arg (first (syntax->datum #'(args ...)))])
                 #`(let ([reqs (manifest-surface-requirements manifest)])
                     (set-manifest-surface-requirements! manifest
                                                         (cons '#,arg reqs))))]
     ['sample-invocation #'(set-manifest-sample-invocation! manifest
                                                            (list args ...))]
     [else #`(#,(format-id #'function "set-manifest-~a!" function-dat) manifest (first (list args ...)))])])

(define-syntax-parser define/manifest
  [(_ name:id form:expr ...)
    #'(begin
        (define temp-manifest (manifest))
        (manifest-execute form temp-manifest) ...
        (define name temp-manifest)
        (println temp-manifest))])

(define-syntax-parser define/fulfillment
  [(_ name:id form:expr ...)
    #'(begin
        (define temp-fulfill (fulfillment))
        (fulfillment-execute form temp-fulfill) ...
        (define name temp-fulfill)
        (println temp-fulfill))])

(define-syntax-parser fulfillment-execute
  [(_ (function args ...) fulfillment)
   (define function-dat (syntax->datum #'function))
   #`(#,(format-id #'here "set-fulfillment-~a!" function-dat) fulfillment (first (list args ...)))])

(define-syntax-parser saa-module-begin
  [(_ prog ...) #'(#%module-begin prog ...)])