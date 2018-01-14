#lang racket

(require syntax/parse/define "define-macros.rkt" "structs.rkt")
(provide #%app #%datum #%module-begin define/manifest define/fulfillment define/action define/app)

(struct app (main-action actions manifest conversations) #:mutable #:transparent)

(define-syntax-parser app-execute
  #:datum-literals (manifest actions conversations)
  [(_ (manifest m) app) #'(set-app-manifest! app m)]
  [(_ (actions action ...) app) #'(set-app-actions! app (list action ...))]
  [(_ (conversations fulfillment ...) app) #'(set-app-conversations! app (list fulfillment ...))])

(define-syntax-parser define/app
  [(_ _ #:main app-main:expr form:expr ...)
   #'(begin
       (define temp-app (app app-main null null null))
       (app-execute form temp-app) ...
       (displayln (app->json temp-app)))])

(define (null-if-null str default) (if (null? str) null default))

(define/match (manifest->json man)
  [((manifest display-name invocation-name short-description long-description
              category small-square-logo-url large-landscape-logo-url company-name
              contact-email terms-of-service-url privacy-url sample-invocation
              introduction testing-instructions voice-name surface-requirements))
   (set! display-name (null-if-null display-name (format "\"displayName\": ~v" display-name)))
   (set! invocation-name (null-if-null invocation-name (format "\"invocationName\": ~v" invocation-name)))
   (set! short-description (null-if-null short-description (format "\"shortDescription\": ~v" short-description)))
   (set! long-description (null-if-null long-description (format "\"longDescription\": ~v" long-description)))
   (set! category (null-if-null category (format "\"category\": ~v" category)))
   (set! small-square-logo-url (null-if-null small-square-logo-url (format "\"smallSquareLogoUrl\": ~v" small-square-logo-url)))
   (set! large-landscape-logo-url (null-if-null large-landscape-logo-url (format "\"largeLandscapeLogoUrl\": ~v" large-landscape-logo-url)))
   (set! company-name (null-if-null company-name (format "\"companyName\": ~v" company-name)))
   (set! contact-email (null-if-null contact-email (format "\"contactEmail\": ~v" contact-email)))
   (set! terms-of-service-url (null-if-null terms-of-service-url (format "\"termsOfServiceUrl\": ~v" terms-of-service-url)))
   (set! privacy-url (null-if-null privacy-url (format "\"privacyUrl\": ~v" privacy-url)))
   (set! introduction (null-if-null introduction (format "\"introduction\": ~v" introduction)))
   (set! testing-instructions (null-if-null testing-instructions (format "\"testingInstructions\": ~v" testing-instructions)))
   (set! voice-name (null-if-null voice-name (format "\"voiceName\": ~v" voice-name)))
   (set! sample-invocation (null-if-null sample-invocation
                                          (format "\"sampleInvocation\": [~a]"
                                                  (string-join (map (λ [x] (format "~v" x)) sample-invocation) ", "))))
   (set! surface-requirements (null-if-null surface-requirements
                                             (format "\"surfaceRequirements\": {\"minimumCapabilities\": [~a]}"
                                                     (string-join (map (λ [x] (format "{\"name\": ~v}"
                                                                                      (symbol->string x)))
                                                                       surface-requirements)
                                                                  ", "))))
   (string-join (filter (λ [x] (not (null? x)))
                 (list display-name invocation-name short-description long-description
                      category small-square-logo-url large-landscape-logo-url company-name
                      contact-email terms-of-service-url privacy-url sample-invocation
                      introduction testing-instructions voice-name surface-requirements))
                ", ")])

(define/match (intent->json int)
  [((intent name params trigger))
   (set! name (null-if-null name (format "\"name\": ~v" (symbol->string name))))
   (define/match (param->json p)
     [((list name type)) (format "{\"name\": ~v, \"type\": ~v}"
                                 (symbol->string name) (symbol->string type))])
   (set! params (null-if-null params (format "\"parameters\": [~a]"
                                              (string-join (map param->json params) ", "))))
   
   (set! trigger (null-if-null trigger (format "\"trigger\": {\"queryPatterns\": [~a]}"
                                                (string-join (map (λ [x] (format "~v" x)) trigger) ", "))))
   (string-join #:before-first "{" #:after-last "}"
                (filter (λ [x] (not (null? x))) (list name params trigger)) ", ")])

(define/match (action->json act)
  [((action json-name fulfillment intent description sign-in-required))
   (set! json-name (null-if-null json-name (format "\"name\": ~v" json-name)))
   (set! fulfillment (null-if-null fulfillment (format "\"fulfillment\": {\"conversationName\": ~v}" fulfillment)))
   (set! intent (null-if-null intent (format "\"intent\": ~a" (intent->json intent))))
   (set! description (null-if-null description (format "\"description\": ~v" description)))
   (set! sign-in-required (null-if-null sign-in-required (format "\"signInRequired\": ~a"
                                                                  (if sign-in-required
                                                                      "true"
                                                                      "false"))))
   (string-join #:before-first "{" #:after-last "}"
                (filter (λ [x] (not (null? x)))
                        (list json-name fulfillment intent description sign-in-required))
                ", ")])

(define/match (conversation->json conv)
  [((fulfillment json-name url api-version headers))
   (define inner-name (null-if-null json-name (format "\"name\": ~v" json-name)))
   (set! url (null-if-null url (format "\"url\": ~v" url)))
   (set! api-version (null-if-null api-version (format "\"fulfillmentApiVersion\": ~a" api-version)))
   (set! headers (format "\"httpHeaders\": {~a}"
                         (string-join (map (λ [header] (format "~v: ~v" (first header) (second header))) headers) ", ")))
   (string-join #:before-first (format "~v: {" json-name) #:after-last "}"
                (filter (λ [x] (not (null? x))) (list inner-name url api-version headers)) ", ")])

(define (app->json app)
  (define manifest-json
    (let ([man (app-manifest app)])
      (null-if-null man (format "\"manifest\": {~a}" (manifest->json man)))))
  (string-join #:before-first "{" #:after-last "}"
               (filter (λ [x] (not (null? x)))
                       (list (format "\"actions\": [~a]"
                                     (string-join (map action->json (app-actions app)) ", "))
                             (format "\"conversations\": {~a}"
                                     (string-join (map conversation->json (app-conversations app)) ", "))
                             manifest-json))
               ", "))