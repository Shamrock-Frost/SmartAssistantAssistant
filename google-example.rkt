#lang s-exp saa/google

(define/manifest sekai-manifest
  (display-name "sekai")
  (invocation-name "sekai")
  (short-description "Orders shoes.")
  (voice-name "male_1")
  ;long-description
  )

(define/fulfillment sekai-app
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
(define/app sekai
  #:main sekai-main
  (manifest sekai-manifest)
  (actions sekai-buy)
  (conversations
   sekai-app))