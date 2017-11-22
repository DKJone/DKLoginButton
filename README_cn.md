DKLoginButton
======
一款带有炫酷转场动画的登录按钮组件

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)
[![CocoaPods](https://img.shields.io/cocoapods/v/TKSubmitTransition.svg)]()

**语言:Swift4.0!! :cat:**
[Swift3.2](https://github.com/DKJone/DKLoginButton/tree/swift3.2)
[Swift2.0](https://github.com/DKJone/DKLoginButton/tree/swift2.0)

灵感来自于  https://dribbble.com/shots/1945593-Login-Home-Screen

本项目中实现了带有动画效果的登录按钮，一般用于 **登录/注销** 等操作

正如你可以看到下面的GIF动画演示，你可以在按钮旋转效果后设置到具体的状态（失败和成功对应不同的动画）

这些效果封装在同一个内文件中，只要按钮继承自这个类机就可以很方便的使用这个动画效果


# Demo
![Demo GIF Animation](https://d13yacurqjgara.cloudfront.net/users/62319/screenshots/1945593/shot.gif "Demo GIF Animation")

![image](https://raw.githubusercontent.com/wwdc14/TKSubmitTransitionObjective-C/master/Demo.gif)
# cocopod添加方法
	pod 'DKLoginButton'
# 手动添加方法
复制demo中的DKButton文件夹到项目即可
# 用法

## 这是 UIButton类的一个子类，使用前初始化并设置相关属性

``` swift
	override func viewDidLoad() {
	super.viewDidLoad()
	// 设置场景
	UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
	let bg = UIImageView(image: UIImage(named: "Login"))
	bg.frame = self.view.frame
	self.view.addSubview(bg)
	// 创建按钮
	var btn = DKTransitionButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 64, height: 44))
	btn.backgroundColor = UIColor(red: 1, green: 0, blue: 128.0 / 255.0, alpha: 1)
	btn.center = self.view.center
	btn.frame.bottom = self.view.frame.height - 60
	btn.setTitle("Sign in", forState: .Normal)
	btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14)
	btn.addTarget(self, action: #selector(onTapButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
	btn.spiner.spinnerColor = UIColor.blackColor()
	self.view.addSubview(btn)
	self.view.bringSubviewToFront(canlogin)
}
```

## 动画使用方法
``` swift
	@IBAction func onTapButton(button: DKTransitionButton) {
	// 开始加载动画
	button.startLoadingAnimation()

	if self.canlogin.on {
	    // 成功，进行界面切换
	button.startSwitchAnimation(1, completion: { () -> () in
	let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SecondViewController")
	secondVC.transitioningDelegate = self
	self.presentViewControllerWithDKAnimation(secondVC, animated: false, completion: nil)
	})
	} else {
    	// 失败返回并提示
	    button.startShakeAnimation(1, completion: {
	    // 提示登录失败
	    print("badend")
	    })
	}
}

```

## 返回到登陆的动画

``` swift
@IBAction func onTapScreen() {
    button.moveToCenterExpand(0) {
	    self.dismissViewControllerAnimated(false, completion: nil)
	}
}
```
