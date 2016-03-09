# On the Map
Second portfolio project for the iOS Developer Nanodegree Program at Udacity

## App Description
Add your current location to a map of locations for other nanodegree students. Also, post a link to your own blog post, project, or portfolio for others to see.

## Project description, grading and example
* https://github.com/udacity/Project-Descriptions-for-Review/blob/master/iOS/On%20the%20Map.md
* https://itunes.apple.com/us/app/on-the-map-portfolio-app/id994619554?mt=8

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
* Facade

## Installation and known issues
It is possible to get the following error during compile: "No such module 'FBSDKCoreKit'", which seems to be a bug related to the framework itself. To overcome this error add the Facebook frameworks manually to the project.
