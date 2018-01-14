# SmartAssistantAssistant
A unified API for creating Alexa Skills and Google Actions

## Overview

SmartAssistantAssistant (SAA) is a racket library/language. 
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
 ```
 
 Likewise, sample declarations for a fulfillment, an action and an app (respectively) will look like:
 ```
 (define/fulfillment sekai-app "sekai-app"
  (url "https://sekai.example.com/sekai-app")
  (headers #:key1 "value1"
           #:key2 "value2") ; Sekai doesn't use headers
  (api-version 2))
 ```
 ```
 (define/action sekai-main "MAIN"
  (intent actions.intent.MAIN)
  (fulfillment sekai-app))
(define/action sekai-buy "BUY"
  (intent (com.example.sekai.BUY (: color SchemaOrg_Color))
          (trigger (query-pattern "find some $SchemaOrg_Color:color sneakers")
                   (query-pattern "buy some blue suede shoes")
                   (query-pattern "get running shoes")))
  (fulfillment sekai-app))
 ```
 ```
 (define/app sekai
  #:main sekai-main
  (manifest sekai-manifest)
  (actions sekai-buy)
  (conversations
   sekai-app))
 ```

## Credit

This project was created for [nwHacks 2018](https://www.nwhacks.io/) with project members:

Brendan Murphy - [github](https://github.com/Shamrock-Frost)

Hazel Pearson - [github](https://github.com/trixiecatsrule)

Leonardo Walcher - [github](https://github.com/leonardow97)

Samuel Young - [github](https://github.com/young438)
