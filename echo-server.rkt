#lang s-exp "saa-server.rkt"

(define-handler/launch-request (launch-handler req-id timestamp locale)
  (values #f "Try saying some words!" (list "Do you like Fire?" "How about Water?" "How does Grass sound?")
                    (list "Get ready to see your words" "Say stuff about fire, water, or grass") (list "SetFire" "SetWater" "SetGrass")))

(define-handler/intent-request (intent-handler intent-name value-map)
  (match intent-name
    ["SetFire" (displayln "Fire!")]
    ["SetWater" (displayln "Water!")]
    ["SetGrass" (displayln "Grass!")])
  (values #f "Try saying some words!" (list "Do you like Fire?" "How about Water?" "How does Grass sound?")
                    (list "Get ready to see your words" "Say stuff about fire, water, or grass") (list "SetFire" "SetWater" "SetGrass")))

(define-handler/session-end (end-handler req-id timestamp reason locale err)
  (values #t "Goodbye word-sayer!" (list "You don't like Fire?" "You also don't like Water?" "Not even Grass?")
          (list ":(" "fine, don't say stuff") (list "SetFire" "SetWater" "SetGrass")))

(init-server 80 launch-handler intent-handler end-handler)