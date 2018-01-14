#lang racket

(require web-server/http syntax/parse/define json)
(provide (all-from-out racket) define-handler/launch-request
         define-handler/intent-request define-handler/session-end)

(define-syntax-parser define-handler/launch-request
  [(_ (name:id req-id:id time:id locale:id) body:expr ...+)
   #'(define (name req-obj)
       (define req-id (hash-ref req-obj "requestId" null))
       (define time (hash-ref req-obj "timestamp" null))
       (define locale (hash-ref req-obj "locale" null))
       body ...)])

(define-syntax-parser define-handler/intent-request
  [(_ (name:id intent-name:id value-map:id) body:expr ...+)
   #'(define (name req-obj)
       (cond
         [(hash-has-key? req-obj "type")
          (define intent-name null)
          (define value-map null)
          (let* ([intent (hash-ref req-obj "intent" null)]
                 [slots (hash-ref intent "slots" null)])
            (set! intent-name (hash-ref intent "name" null))
            (set! value-map (for/hash ([(slot-name slot-obj) slots])
                              (values slot-name (hash-ref (hash-ref (first (hash-ref (first (hash-ref (hash-ref slot-obj "resolutions" null) "resultionsPerAuthority" null)) "values" null)) "value" null) "name" null)))))
          body ...]
         [(hash-has-key? req-obj "user")
          (define intent-name (hash-ref (hash-ref req-obj "inputs" null) "intent" null))
          (define value-map (for/hash ([arg-obj (hash-ref (hash-ref req-obj "inputs" null) "arguments" null)])
                              (values (hash-ref arg-obj "name" null) (hash-ref arg-obj "textValue" null))))
          body ...]))])

(define-syntax-parser define-handler/session-end
  [(_ (name:id req-id:id time:id reason:id locale:id error:id) body:expr ...+)
   #'(define (name req-obj)
       (define req-id (hash-ref req-obj "requestId" null))
       (define time (hash-ref req-obj "timestamp" null))
       (define reason (hash-ref req-obj "reason" null))
       (define locale (hash-ref req-obj "locale" null))
       (define error (hash-ref req-obj "error" null))
       body ...)])
