#lang s-exp saa/alexa

(define/action hello-world "intents")
(define/actions "slot"
(slot name "HelloWorld"
        (name ("hello"))
        (type ("LIST_OF_TYPES"))
        (name ("Date"))
        (type ("AMAZON.DATE")))
        


