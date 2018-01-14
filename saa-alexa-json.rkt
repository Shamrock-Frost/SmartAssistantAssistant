#lang racket

(require syntax/parse/define "define-macros.rkt" "structs.rkt")
(provide #%app #%datum #%module-begin define/manifest define/fulfillment define/action define/app)

(struct slot (name type))
(struct alexa-intent (name slots))
(struct utterance (intent-name raw))
(custom-struct app (intents utterances))

(define/match (handle-action ac ap)
  [((action json-name _ (intent intent-id parameters trigger) _ _) app)
   (let ([prev-intents (app-intents app)]
         [prev-utterances (app-utterances app)])
     (set-app-intents! app
      (cons (alexa-intent intent-id
                          (map (λ [syms] (match-let ([(list name ty) (map symbol->string syms)])
                                           (slot name ty)))
                               parameters))
            prev-intents))
     (set-app-utterances! app
      (append (map (λ [raw] (utterance json-name raw)) trigger)
              prev-intents)))]
  [((action json-name _ intent-id _ _) app)
   (set-app-intents! app (cons (alexa-intent intent-id null) (app-intents app)))])

(define-syntax-parser app-execute
  #:datum-literals (manifest actions conversations)
  [(_ (actions acts ...) app)
   #'(for ([act (list acts ...)])
       (handle-action act app))]
  [(_ (conversations fulfillment ...) app) #'(void)]
  [(_ (locale s:string) app) #'(void)]
  [(_ (manifest m) app) #'(void)])

(define-syntax-parser define/app
  [(_ name:id #:main app-main:expr form:expr ...)
   (define dir-name (symbol->string (syntax->datum #'name)))
   #`(begin
       (define temp-app (app))
       (app-execute form temp-app) ...
       (handle-action app-main temp-app)
       (make-directory #,dir-name)
       (match (app->json temp-app)
         [(list intents-json utterances)
          (displayln intents-json (open-output-file (string-append #,dir-name "/" "intents.json")))
          (displayln utterances (open-output-file (string-append #,dir-name "/" "utterances.txt")))]))])

(define-simple-macro (null-if-null str default) (if (null? str) null default))

(define/match (alexa-intent->json int)
  [((alexa-intent intent-name (list slots ...)))
   (format "{\"intent\": ~v, \"slots\": [~a]}" intent-name
           (string-join (map (λ [slot] (format "{\"name\": ~v, \"type\": ~v}"
                                               (slot-name slot) (slot-type slot)))
                             slots)
                        ", "))])

(define (app->json app)
  (list
   (format "{\"intents\": ~a}"
           (string-join #:before-first "[" #:after-last "]"
                        (map (λ [x] (alexa-intent->json x)) (app-intents app))
                        ", "))
   (string-join #:after-last "\n"
                (map (λ [x] (format "~a ~a" (utterance-intent-name x) (utterance-raw x))) (app-utterances app))
                "\n")))