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
The fulfillment points the listener (`action`) to the funtional backend
The aciton defines what the app should listen for
The app defines the entire app.

A sample declaration might be:

## Credit

This project was created for [nwHacks 2018](https://www.nwhacks.io/) with project members:

Brendan Murphy - [github](https://github.com/Shamrock-Frost)

Hazel Pearson - [github](https://github.com/trixiecatsrule)

Leonardo Walcher - [github](https://github.com/leonardow97)

Samuel Young - [github](https://github.com/young438)
