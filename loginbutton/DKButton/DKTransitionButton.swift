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
open class DKTransitionButton: UIButton, CAAnimationDelegate {
    // MARK: - 属性
    // 内部圆旋转动画层
    lazy var spiner: SpinerLayer! = {
        let s = SpinerLayer(frame: self.frame)
        self.layer.addSublayer(s)
        return s
    }()
    
    var cachedTitle: String?
    /// 旋转的圆圈颜色
    @IBInspectable open var spinnerColor: UIColor = UIColor.white {
        didSet {
            spiner.spinnerColor = spinnerColor
        }
    }
    /// 加载动画完成的回调
    open var succeedCompletion: (() -> ())? = nil // 成功的回调
    open var failedCompletion: (() -> ())? = nil // 失败的回调
    let springGoEase = CAMediaTimingFunction(controlPoints: 0.45, -0.36, 0.44, 0.92)
    let shrinkCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    let expandCurve = CAMediaTimingFunction(controlPoints: 0.95, 0.02, 1, 0.05)
    let shrinkDuration: CFTimeInterval = 0.2
    /// 设置圆角
    @IBInspectable open var normalCornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = normalCornerRadius
        }
    }
    
    // MARK: - 初始化方法
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
    // MARK: - 动画
    
    /// 开始缩小并旋转
    open func startLoadingAnimation() {
        self.isUserInteractionEnabled = false
        self.cachedTitle = title(for: UIControlState())
        self.setTitle("", for: UIControlState())
        UIView.animate(withDuration: 0.1, animations: { [unowned self]() -> () in
            self.layer.cornerRadius = self.frame.height / 2
            }, completion: { [unowned self](done) -> () in
                self.shrink()
                _ = Timer.schedule(delay: self.shrinkDuration - 0.25) { _ in
                    self.spiner.animation()
                }
        })
        
    }
    
    /// 加载动画结束,切换界面
    ///
    /// - Parameters:
    ///   - delay: 延迟时间
    ///   - completion: 完成时回调
    open func startSwitchAnimation(_ delay: TimeInterval, completion: (() -> ())?) {
        _ = Timer.schedule(delay: delay) { [unowned self] timer in
            self.succeedCompletion = completion
            self.expand()
            self.spiner.stopAnimation()
        }
    }
    
    /// 加载动画结束,返回原位并震动提醒
    ///
    /// - Parameters:
    ///   - delay: 延迟时间
    ///   - completion: 完成时回调
    open func startShakeAnimation(_ delay: TimeInterval, completion: (() -> ())?) {
        self.failedCompletion = completion
        _ = Timer.schedule(delay: delay) { [unowned self] timer in
            self.spiner.stopAnimation()
            self.deShrink()
        }
        
        _ = Timer.schedule(delay: delay + shrinkDuration) { [unowned self] timer in
            self.returnToOriginalState()
            let animation = self.shakeAnimation(self.frame, times: 4, duration: 0.5, vigour: 0.03)
            self.layer.add(animation, forKey: kCATransition)
            completion?()
        }
    }
    
    
    /// 动画停止了
    ///
    /// - Parameters:
    ///   - anim: 执行的动画
    ///   - flag: 是否完成
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let a = anim as! CABasicAnimation
        if a.keyPath == "transform.scale" {
            succeedCompletion?()
            _ = Timer.schedule(delay: 1) { timer in
                self.returnToOriginalState()
            }
        }
    }
    
    /// 回到初始状态
    open func returnToOriginalState() {
        self.layer.removeAllAnimations()
        self.setTitle(self.cachedTitle, for: UIControlState())
        self.spiner.stopAnimation()
        self.isUserInteractionEnabled = true
    }
    /// 宽度变化动画-收缩
    func shrink() {
        let shrinkAnim = CABasicAnimation(keyPath: "bounds.size.width")
        shrinkAnim.fromValue = frame.width
        shrinkAnim.toValue = frame.height
        shrinkAnim.duration = shrinkDuration
        shrinkAnim.timingFunction = shrinkCurve
        shrinkAnim.fillMode = kCAFillModeForwards
        shrinkAnim.isRemovedOnCompletion = false
        layer.add(shrinkAnim, forKey: shrinkAnim.keyPath)
    }
    /// 宽度变化动画-放大
    func deShrink() {
        let shrinkAnim = CABasicAnimation(keyPath: "bounds.size.width")
        shrinkAnim.fromValue = frame.height
        shrinkAnim.toValue = frame.width
        shrinkAnim.duration = shrinkDuration
        // shrinkAnim.timingFunction = expandCurve
        shrinkAnim.fillMode = kCAFillModeForwards
        shrinkAnim.isRemovedOnCompletion = false
        layer.add(shrinkAnim, forKey: shrinkAnim.keyPath)
    }
    
    /// 放大到全屏
    func expand() {
        let expandAnim = CABasicAnimation(keyPath: "transform.scale")
        expandAnim.fromValue = 1.0
        expandAnim.toValue = 30.0
        expandAnim.timingFunction = expandCurve
        expandAnim.duration = 0.5
        expandAnim.delegate = self
        expandAnim.fillMode = kCAFillModeForwards
        expandAnim.isRemovedOnCompletion = false
        layer.add(expandAnim, forKey: expandAnim.keyPath)
    }
    
    /// 震动动画,调用时添加以下代码
    /// example:
    /// let animation=self.shakeAnimation(self.layer.frame,times:30,duration: 10.0,vigour: 0.102)
    /// self.layer.addAnimation(animation, forKey: kCATransition)
    /// - Parameters:
    ///   - frame: 需要震动的窗体
    ///   - times: 震动次数
    ///   - duration: 震动时间
    ///   - vigour: 震动幅度
    /// - Returns: 震动动画
    func shakeAnimation(_ frame: CGRect, times: Int, duration: Double, vigour: CGFloat) -> CAKeyframeAnimation {
        let shakeAnimation = CAKeyframeAnimation(keyPath: "position")
        
        let shakePath = CGMutablePath()
        shakePath.move(to: CGPoint(x: frame.midX, y: frame.midY))
        for _ in 0..<times {
            shakePath.addLine(to: CGPoint(x: frame.midX - frame.size.width * vigour, y: frame.midY))
            shakePath.addLine(to: CGPoint(x: frame.midX + frame.size.width * vigour, y: frame.midY))
        }
        shakePath.closeSubpath()
        shakeAnimation.path = shakePath
        shakeAnimation.duration = duration
        return shakeAnimation
    }
    
    /// 跳转动画从原位置移动到屏幕中间并放大到全屏
    ///
    /// - Parameters:
    ///   - delay: 延迟时间
    ///   - completion: 动画完成执行的闭包
    open func moveToCenterExpand(_ delay: TimeInterval, completion: (() -> ())?) {
        self.succeedCompletion = completion
        self.setTitle("", for: UIControlState())
        _ = Timer.schedule(delay: delay) { [unowned self] time in
            UIView.animate(withDuration: 0.8, animations: {
                self.center = (UIApplication.shared.keyWindow?.center
                    )!
                self.expand()
            }, completion: { isend in
            })
        }
    }
}

