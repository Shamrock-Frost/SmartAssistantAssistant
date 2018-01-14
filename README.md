# SmartAssistantAssistant
A unified API for creating Alexa Skills and Google Actions

## Overview

[SmartAssistantAssistant](smartassistantsquared.com) (SAA) is a racket library/language. 
It's technically two languages, saa-alexa-json and saa-google-json. 
They're parsed differently, but written exactly the same way. 
To get your code to compile on the other, simply switch the #lang. 
No other code changes required!

## How to use

Write your saa-alexa-json or saa-google-json file for your desired skill/action. Then complete a saa-server file to implement.

**saa-alexa-json and saa-google-json**
The first important line is your #lang. You can define this as either. In this example, I use Alexa.
```
#lang s-exp "saa-alexa-json.rkt"
```

You need a manifest, a fulfillment, an action, and an app. 
The manifest defines the app's description (name, description, etc.)
The fulfillment points the listener (`action`) to the funtional backend.
The action defines what the app should listen for.
The app defines the entire app.

A sample declaration for a manifest might be:
```
(define/manifest shoe-manifest
  (display-name "Shoes")
  (invocation-name "shoes")
  (long-description "Orders shoes.")
  (voice-name "male_1")
  (sample-invocation
   "Buy me shoes"
   "Purchase shoes")
  (require actions.capabilities.AUDIO_OUTPUT)
  (require actions.capabilities.AUDIO_INPUT))
 ```
 
 Likewise, sample declarations for a fulfillment, an action and an app (respectively) will look like:
 ```
 (define/fulfillment shoe-app "shoe-app"
  (url "https://shoe.example.com/shoe-app")
  (headers #:key1 "value1"
           #:key2 "value2")
  (api-version 2))
 ```
 ```
 (define/action shoe-main "MAIN"
  (intent actions.intent.MAIN)
  (fulfillment shoe-app))
(define/action shoe-buy "BUY"
  (intent (com.example.shoe.BUY (: color SchemaOrg_Color))
          (trigger (query-pattern "find some $SchemaOrg_Color:color sneakers")
                   (query-pattern "buy some blue suede shoes")
                   (query-pattern "get running shoes")))
  (fulfillment shoe-app))
 ```
 ```
 (define/app shoe
  #:main shoe-main
  (manifest shoe-manifest)
  (actions shoe-buy)
  (conversations
   shoe-app))
 ```

## Credit

This project was created for [nwHacks 2018](https://www.nwhacks.io/) with project members:

Brendan Murphy - [github](https://github.com/Shamrock-Frost)

Hazel Pearson - [github](https://github.com/trixiecatsrule)

Leonardo Walcher - [github](https://github.com/leonardow97)

Samuel Young - [github](https://github.com/young438)
