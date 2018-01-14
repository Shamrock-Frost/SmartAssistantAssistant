#lang s-exp "saa-google-json.rkt"

(define/fulfillment echo-app "echo-app"
  (url "34.214.214.2")
  (api-version 2))

(define/action echo-main "MAIN"
  (intent (SayFire)
          (trigger (query-pattern "set fire")
                   (query-pattern "burn them")
                   (query-pattern "light it up")))
  (intent (SayWater)
          (trigger (query-pattern "soak them")
                   (query-pattern "set water")
                   (query-pattern "drink it up")
                   (query-pattern "melt some ice")))
  (intent (SayGrass)
          (trigger (query-pattern "set grass")
                   (query-pattern "get all grassy")
                   (query-pattern "grow on them")
                   (query-pattern "plants plants plants"))))

(define/app echo
  #:main echo-main
  (conversations echo-app))