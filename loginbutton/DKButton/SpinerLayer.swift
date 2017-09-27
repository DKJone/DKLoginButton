import UIKit

/// 内部圆圈的旋转动画
class SpinerLayer: CAShapeLayer {
    
    var spinnerColor = UIColor.white {
        didSet {
            strokeColor = spinnerColor.cgColor
        }
    }
    
    init(frame: CGRect) {
        super.init()
        // 画圆
        let radius: CGFloat = (frame.height / 2) * 0.5
        self.frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.height)
        let center = CGPoint(x: frame.height / 2, y: bounds.center.y)
        let startAngle = 0 - (Double.pi / 2)
        let endAngle = Double.pi * 2 - (Double.pi / 2)
        let clockwise: Bool = true
        
        self.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: clockwise).cgPath
        
        // 设置线的属性
        self.fillColor = nil
        self.strokeColor = spinnerColor.cgColor
        self.lineWidth = 1
        // 设置动画结束位置
        self.strokeEnd = 0.4
        self.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /**
     添加动画
     */
    func animation() {
        self.isHidden = false
        // 路径为旋转的动画
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        // 动画起止位置
        rotate.fromValue = 0
        rotate.toValue = Double.pi * 2
        rotate.duration = 0.4
        rotate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        // 重复次数
        rotate.repeatCount = HUGE
        rotate.fillMode = kCAFillModeForwards
        rotate.isRemovedOnCompletion = false
        self.add(rotate, forKey: rotate.keyPath)
        
    }
    /**
     停止动画,隐藏界面
     */
    func stopAnimation() {
        self.isHidden = true
        self.removeAllAnimations()
    }
}

