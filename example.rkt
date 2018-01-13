#lang s-exp saa/google

(define/action tide-main "MAIN"
  (intent actions.intent.MAIN)
  (fulfillment sekai-app))
(define/action tide-buy "BUY"
  (intent (com.example.sekai.BUY {: color SchemaOrg_Color}))
  (trigger (query-pattern "find some $SchemaOrg_Color:color sneakers")
           (query-pattern "buy some blue suede shoes")
           (query-pattern "get running shoes"))
  (fulfillment sekai-app))
(define/app tides
  #:main tide-main
  tide-buy)