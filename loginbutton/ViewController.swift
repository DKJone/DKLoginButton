//
//  ViewController.swift
//  loginbutton
//
//  Created by mac on 16/7/20.
//  Copyright © 2016年 南京麦伦思. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	var btn: DKTransitionButton!
	@IBOutlet weak var canlogin: UISwitch!
	override func viewDidLoad() {
		super.viewDidLoad()
		// 设置场景
		UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
		let bg = UIImageView(image: UIImage(named: "Login"))
		bg.frame = self.view.frame
		self.view.addSubview(bg)
		// 创建按钮
		btn = DKTransitionButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 64, height: 44))
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

}

// MARK: UIViewControllerTransitioningDelegate
extension ViewController: UIViewControllerTransitioningDelegate {
	func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		// return TKFadeInAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
		return nil
	}

	func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return nil
	}
}

