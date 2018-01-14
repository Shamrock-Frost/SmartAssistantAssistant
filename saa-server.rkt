#lang racket

(require web-server/http web-server/http/request-structs syntax/parse/define)
(provide (all-from-out racket))

(define-syntax-parser define-handler/launch-request
  [(_ (name:id req-id:id time:id locale:id) body:expr ...+)
   #'(define (name req-obj)
       (define req-id (hash-ref req-obj "requestId"))
       (define time (hash-ref req-obj "timestamp"))
       (define locale (hash-ref req-obj "locale"))
       body ...)])