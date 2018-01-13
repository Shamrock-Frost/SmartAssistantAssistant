#lang s-exp "main.rkt"

(define/manifest sekai-manifest
  (display-name "sekai")
  (invocation-name "sekai")
  (long-description "Orders shoes.")
  (voice-name "male_1")
  (long-description "weifiewueWFU")
  (sample-invocation
   "ffiuwfj"
   "dqwqdwijq")
  (require actions.capabilities.AUDIO_OUTPUT)
  (require actions.capabilities.AUDIO_INPUT))

#;(define/fulfillment sekai-app
  (url "https://sekai.example.com/sekai-app")
  ;(headers {key1 value1}
    ;           {key2 value2}) Sekai doesn't use headers
  (api-version 2))

(define/action sekai-main "MAIN"
  (intent actions.intent.MAIN)
  (fulfillment sekai-app))
(define/action sekai-buy "BUY"
  (intent (com.example.sekai.BUY (: color SchemaOrg_Color))
          (trigger (query-pattern "find some $SchemaOrg_Color:color sneakers")
                   (query-pattern "buy some blue suede shoes")
                   (query-pattern "get running shoes")))
  (fulfillment sekai-app))
#;(define/app sekai
  #:main sekai-main
  (manifest sekai-manifest)
  (actions sekai-buy)
  (conversations
   sekai-app))