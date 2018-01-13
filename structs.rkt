#lang racket

(require syntax/parse/define)
(provide (struct-out manifest) (struct-out fulfillment) (struct-out action) (struct-out intent))

(define-syntax-parser custom-struct
  [(_ name:id (field:id ...) option ...)
   #`(struct name ([field #:auto] ...) option ... #:transparent #:mutable #:auto-value null)])

(custom-struct manifest
  (display-name invocation-name short-description long-description
   category small-square-logo-url large-landscape-logo-url company-name
   contact-email terms-of-service-url privacy-url sample-invocation
   introduction testing-instructions voice-name surface-requirements))

(custom-struct fulfillment
  (url api-version headers))

(custom-struct action
  (json-name fulfillment intent description sign-in-required))

(struct intent
  (name parameters trigger)
  #:transparent)