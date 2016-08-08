# DKLoginButton
A  login button with Cool animation and easy to use

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)
[![CocoaPods](https://img.shields.io/cocoapods/v/TKSubmitTransition.svg)]()

**Swift2.0!! :cat:**

Inpired by https://dribbble.com/shots/1945593-Login-Home-Screen

I created Animated UIButton of Loading Animation and Transition Animation.

As you can see in the GIF Animation Demo below, you can find the “Sign in” button rolling and after that, next UIViewController will fade-in. 

I made them as classes and you can use it with ease.

[Objective-C version is here.](https://github.com/wwdc14/HySubmitTransitionObjective-C)

# Demo
![Demo GIF Animation](https://github.com/entotsu/TKSubmitTransition/blob/master/demo.gif "Demo GIF Animation")

# Installation
	pod 'TKSubmitTransition'
	use_frameworks!

# Usage

## This is SubClass of UIButton

``` swift
btn = TKTransitionSubmitButton(frame: CGRectMake(0, 0, 44, 44))
```

## Animation Method
``` swift
func didStartYourLoading() {
    btn.startLoadingAnimation()
}

func didFinishYourLoading() {
    btn.startFinishAnimation {
	    //Your Transition
		let secondVC = SecondViewController()
		secondVC.transitioningDelegate = self
		self.presentViewController(secondVC, animated: true, completion: nil)
    }
}

```

## TKFadeInAnimator
This Library also supply fade-in Animator Class of `UIViewControllerAnimatedTransitioning`.

Please use This for transition animation.

### Usage

#### please use UIViewControllerTransitioningDelegate
> class ViewController: UIViewController, UIViewControllerTransitioningDelegate {

`secondVC.transitioningDelegate = self`

``` swift
// MARK: UIViewControllerTransitioningDelegate
func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let fadeInAnimator = TKFadeInAnimator()
    return fadeInAnimator
}
func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return nil
}
```
