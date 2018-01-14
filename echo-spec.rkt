#lang s-exp "saa-alexa-json.rkt"

(define/fulfillment echo-app "echo-app"
  (url "34.214.214.2")
  (api-version 2))

(define/action echo-fire "MAIN"
  (intent (SayFire)
          (trigger (query-pattern "set fire")
                   (query-pattern "burn them")
                   (query-pattern "light it up"))))
(define/action echo-water "WATER"
  (intent (SayWater)
          (trigger (query-pattern "soak them")
                   (query-pattern "set water")
                   (query-pattern "drink it up")
                   (query-pattern "melt some ice"))))
(define/action echo-grass "GRASS"
  (intent (SayGrass)
          (trigger (query-pattern "set grass")
                   (query-pattern "get all grassy")
                   (query-pattern "grow on them")
                   (query-pattern "plants plants plants"))))

(define/app echo
  #:main echo-fire
  (conversations echo-app)
  (actions echo-grass echo-water))