//
//  DKTransitionButton.swift
//  loginbutton
//
//  Created by mac on 16/7/20.
//  Copyright © 2016年 南京麦伦思. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable
public class DKTransitionButton: UIButton {
// MARK: - 属性
	// 内部圆旋转动画层
	lazy var spiner: SpinerLayer! = {
		let s = SpinerLayer(frame: self.frame)
		self.layer.addSublayer(s)
		return s
	}()

	var cachedTitle: String?
	/// 旋转的圆圈颜色
	@IBInspectable public var spinnerColor: UIColor = UIColor.whiteColor() {
		didSet {
			spiner.spinnerColor = spinnerColor
		}
	}
	/// 加载动画完成的回调
	public var succeedCompletion: (() -> ())? = nil // 成功的回调
	public var failedCompletion: (() -> ())? = nil // 失败的回调
	let springGoEase = CAMediaTimingFunction(controlPoints: 0.45, -0.36, 0.44, 0.92)
	let shrinkCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
	let expandCurve = CAMediaTimingFunction(controlPoints: 0.95, 0.02, 1, 0.05)
	let shrinkDuration: CFTimeInterval = 0.2
	/// 设置圆角
	@IBInspectable public var normalCornerRadius: CGFloat? = 0.0 {
		didSet {
			self.layer.cornerRadius = normalCornerRadius!
		}
	}

//MARK: - 初始化方法
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.setup()
	}

	public required init!(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
		self.setup()
	}
	func setup() {
		self.clipsToBounds = true
		self.normalCornerRadius = self.frame.height / 2
		self.layer.masksToBounds = true
		spiner.spinnerColor = spinnerColor
	}
//MARK: - 动画
	/**
	 Description: 开始缩小并旋转
	 */
	public func startLoadingAnimation() {
		self.userInteractionEnabled = false
		self.cachedTitle = titleForState(.Normal)
		self.setTitle("", forState: .Normal)
		UIView.animateWithDuration(0.1, animations: { () -> Void in
			self.layer.cornerRadius = self.frame.height / 2
		}) { (done) -> Void in
			self.shrink()
			NSTimer.schedule(delay: self.shrinkDuration - 0.25) { timer in
				self.spiner.animation()
			}
		}

	}
	/**
	 Description: 加载动画结束,切换界面

	 - parameter delay:      延迟时间
	 - parameter completion: 完成时回调
	 */
	public func startSwitchAnimation(delay: NSTimeInterval, completion: (() -> ())?) {
		NSTimer.schedule(delay: delay) { timer in
			self.succeedCompletion = completion
			self.expand()
			self.spiner.stopAnimation()
		}
	}
	/**
	 Description: 加载动画结束,返回原位并震动提醒

	 - parameter delay:      延迟时间
	 - parameter completion: 完成时回调
	 */
	public func startShakeAnimation(delay: NSTimeInterval, completion: (() -> ())?) {
		self.failedCompletion = completion
		NSTimer.schedule(delay: delay) { timer in
			self.spiner.stopAnimation()
			self.deShrink()
		}

		NSTimer.schedule(delay: delay + shrinkDuration) { (timer) in
			self.returnToOriginalState()
			let animation = self.shakeAnimation(self.frame, times: 4, duration: 0.5, vigour: 0.03)
			self.layer.addAnimation(animation, forKey: kCATransition)
			completion?()
		}
	}

	/**
	 Description: 动画停止了

	 - parameter anim: 执行的动画
	 - parameter flag: 是否完成
	 */
	public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
		let a = anim as! CABasicAnimation
		if a.keyPath == "transform.scale" {
			succeedCompletion?()
			NSTimer.schedule(delay: 1) { timer in
				self.returnToOriginalState()
			}
		}
	}

	/**
	 Description: 回到初始状态
	 */
	public func returnToOriginalState() {
		self.layer.removeAllAnimations()
		self.setTitle(self.cachedTitle, forState: .Normal)
		self.spiner.stopAnimation()
		self.userInteractionEnabled = true
	}
	// 宽度变化动画-收缩
	func shrink() {
		let shrinkAnim = CABasicAnimation(keyPath: "bounds.size.width")
		shrinkAnim.fromValue = frame.width
		shrinkAnim.toValue = frame.height
		shrinkAnim.duration = shrinkDuration
		shrinkAnim.timingFunction = shrinkCurve
		shrinkAnim.fillMode = kCAFillModeForwards
		shrinkAnim.removedOnCompletion = false
		layer.addAnimation(shrinkAnim, forKey: shrinkAnim.keyPath)
	}
	// 宽度变化动画-放大
	func deShrink() {
		let shrinkAnim = CABasicAnimation(keyPath: "bounds.size.width")
		shrinkAnim.fromValue = frame.height
		shrinkAnim.toValue = frame.width
		shrinkAnim.duration = shrinkDuration
		// shrinkAnim.timingFunction = expandCurve
		shrinkAnim.fillMode = kCAFillModeForwards
		shrinkAnim.removedOnCompletion = false
		layer.addAnimation(shrinkAnim, forKey: shrinkAnim.keyPath)
	}
	/**
	 Description: 放大到全屏
	 */
	func expand() {
		let expandAnim = CABasicAnimation(keyPath: "transform.scale")
		expandAnim.fromValue = 1.0
		expandAnim.toValue = 30.0
		expandAnim.timingFunction = expandCurve
		expandAnim.duration = 0.5
		expandAnim.delegate = self
		expandAnim.fillMode = kCAFillModeForwards
		expandAnim.removedOnCompletion = false
		layer.addAnimation(expandAnim, forKey: expandAnim.keyPath)
	}

	/**
	 Description: 震动动画,调用时添加以下代码
	 let animation=self.shakeAnimation(self.layer.frame,times:30,duration: 10.0,vigour: 0.102)
	 self.layer.addAnimation(animation, forKey: kCATransition)

	 - parameter frame:    需要震动的窗体
	 - parameter times:    震动次数
	 - parameter duration: 震动时间
	 - parameter vigour:   震动幅度

	 - returns: 震动动画
	 */
	func shakeAnimation(frame: CGRect, times: Int, duration: Double, vigour: CGFloat) -> CAKeyframeAnimation {
		let shakeAnimation = CAKeyframeAnimation(keyPath: "position")

		let shakePath = CGPathCreateMutable()
		CGPathMoveToPoint(shakePath, nil, CGRectGetMidX(frame), CGRectGetMidY(frame))
		for _ in 0..<times {
			CGPathAddLineToPoint(shakePath, nil, CGRectGetMidX(frame) - frame.size.width * vigour, CGRectGetMidY(frame));
			CGPathAddLineToPoint(shakePath, nil, CGRectGetMidX(frame) + frame.size.width * vigour, CGRectGetMidY(frame));
		}
		CGPathCloseSubpath(shakePath);
		shakeAnimation.path = shakePath;
		shakeAnimation.duration = duration;
		return shakeAnimation;
	}

	/**
	 跳转动画从原位置移动到屏幕中间并放大到全屏

	 - parameter delay:      延迟时间
	 - parameter completion: 动画完成执行的必报
	 */
	public func moveToCenterExpand(delay: NSTimeInterval, completion: (() -> ())?) {
		self.succeedCompletion = completion
		self.setTitle("", forState: .Normal)
		NSTimer.schedule(delay: delay) { [unowned self] time in
			UIView.animateWithDuration(0.8, animations: {
				self.center = (UIApplication.sharedApplication().keyWindow?.center
				)!
				self.expand()
				}, completion: { (isend) in
			})
		}
	}
}