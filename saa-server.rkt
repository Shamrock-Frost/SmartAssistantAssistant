#lang racket

(require web-server/http syntax/parse/define)
(provide (all-from-out racket))

(define-syntax-parser define-handler/launch-request
  [(_ (name:id req-id:id time:id locale:id) body:expr ...+)
   #'(define (name req-obj)
       (define req-id (hash-ref req-obj "requestId"))
       (define time (hash-ref req-obj "timestamp"))
       (define locale (hash-ref req-obj "locale"))
       body ...)])

(define-syntax-parser define-handler/intent-request
  [(_ (name:id intent-name:id value-map:id) body:expr ...+)
   #'(define (name req-obj)
       (cond
         [(hash-has-key? req-obj "type")
          (define intent (hash-ref req-obj "intent"))
          (define intent-name (hash-ref intent "name"))
          (define slots (hash-ref intent "slots"))
          (define value-map (for/hash ([(slot-name slot-obj) slots])
                              (values slot-name (hash-ref (hash-ref (first (hash-ref (first (hash-ref (hash-ref slot-obj "resolutions") "resultionsPerAuthority")) "values")) "value") "name"))))
          body ...]
         [(hash-has-key? req-obj "user")
          (define inputs (hash-ref req-obj "inputs"))
          (define intent-name (hash-ref input "intent"))
          (define value-map (for/hash ([arg-obj (hash-ref input "arguments")])
                              (values (hash-ref arg-obj "name") (hash-ref arg-obj "textValue"))))]))])