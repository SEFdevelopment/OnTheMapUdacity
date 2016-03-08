# On the Map
Second portfolio project for the iOS Developer Nanodegree Program at Udacity

## App Description
Add your current location to a map of locations for other nanodegree students. Also, post a link to your own blog post, project, or portfolio for others to see.

## iOS frameworks and technologies used
* UIKit
* Foundation
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
