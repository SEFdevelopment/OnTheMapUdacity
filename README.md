# On the Map
Second portfolio project for the iOS Developer Nanodegree Program at Udacity

## App Description
Add your current location to a map of locations for other nanodegree students. Also, post a link to your own blog post, project, or portfolio for others to see.

## Project description, grading and example
* https://github.com/udacity/Project-Descriptions-for-Review/blob/master/iOS/On%20the%20Map.md
* https://itunes.apple.com/us/app/on-the-map-portfolio-app/id994619554?mt=8

## Installation and known issues
It is possible to get the following error during compile: "No such module 'FBSDKCoreKit'", which seems to be, according many comments, a bug related to the framework itself. To overcome this error do one of the following:

1) Download, unzip and run the On.The.Map.zip file from this repository.

2) Add the Facebook sdk manually.
* Delete the framework files from the project
* Add the framework files manually according to the following instructions: https://developers.facebook.com/docs/ios/getting-started (libraries to be added: Bolts, CoreKit, LoginKit).

## iOS frameworks and technologies used
* UIKit
* Foundation
* Map Kit
* Core Location
* SystemConfiguration
* FBSDKCoreKit and FBSDKLoginKit (for authentification via Facebook)
* Networking via NSURLSession
* Concurrency via GCD


## Adopted design patterns
* MVC
* Target-Action
* Delegation
* Singleton
* Lazy initialization
* Error handling
* Notifications
* Facade

