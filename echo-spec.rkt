#lang s-exp "saa-google-json.rkt"

(define/fulfillment echo-app "echo-app"
  (url "34.214.214.2")
  (api-version 2))

(define/action dummy-main "MAIN"
  (intent actions.intent.MAIN)
  (fulfillment echo-app))
(define/action echo-fire "FIRE"
  (intent (SayFire)
          (trigger (query-pattern "set fire")
                   (query-pattern "burn them")
                   (query-pattern "light it up")))
  (fulfillment echo-app))
(define/action echo-water "WATER"
  (intent (SayWater)
          (trigger (query-pattern "soak them")
                   (query-pattern "set water")
                   (query-pattern "drink it up")
                   (query-pattern "melt some ice")))
  (fulfillment echo-app))
(define/action echo-grass "GRASS"
  (intent (SayGrass)
          (trigger (query-pattern "set grass")
                   (query-pattern "get all grassy")
                   (query-pattern "grow on them")
                   (query-pattern "plants plants plants")))
  (fulfillment echo-app))

(define/app echo
  #:main dummy-main
  (conversations echo-app)
  (actions echo-grass echo-water echo-fire))