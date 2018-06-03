# Tempus
Easy Poll Assistant App

NOTE: This is an open-source project aimed towards learning and guidance for Swift Code.

Tempus is a poll assistant app that can help people quickly give a definite winner for a voting contests.

## Requirements

- Swift 4.1
- iOS 11
- Xcode 9.3

## Build Instructions

1. Install the latest [Xcode developer tools](https://developer.apple.com/xcode/downloads/) from Apple.
2. Clone the repository:

```shell
git clone https://github.com/buenaflor/Tempus.git
```

3. Install dependencies in terminal

```shell
'pod install'
```

5. Open `Tempus.xcworkspace` in Xcode.
6. Run build in Xcode.

## Pod Information
Pods used in this repository are (of current state):

1. Firebase/Core
2. Firebase/auth
3. Firebase/Firestore
4. NVActivityIndicatorView

## Firebase
What is Firebase and why do you use it?

Firebase is a platform made by Google that can help you store data, analyse statistics and much more. There are a lot of things you can do with it and for Tempus I am using the NoSQL Firestore database and the Firebase Authentication.

If you are interested in Firebase, read more about it [here](https://firebase.google.com/docs/)

## NVActivityIndicatorView

NVActivityIndicatorView is an amazing library published by [ninjaprox](https://github.com/ninjaprox/NVActivityIndicatorView) that contains a lot of custom animated ActivityIndicatorViews.

Using them is almost the same as using the ActivityIndicators from the standard Apple API. The only thing to be wary of is to give it proper width and height anchors if you are using AutoLayout.

## AutoLayout Extensions

