//
//  DKViewControllerExt.swift
//  loginbutton
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 南京麦伦思. All rights reserved.
//

import Foundation
import UIKit

// 预留文件，准备完成界面跳转后界面元素加载动画
extension UIViewController {
    
    func presentViewControllerWithDKAnimation(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        if self.view.subviews.count > 0 {
            self.animatied(self.view)
        }
        
        self.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    func animatied(_ view: UIView) {
        // 动画显示
        // let frame = view.frame
        let treed = CATransform3DMakeTranslation(0, 0, 100)
        
        let anim = CABasicAnimation(keyPath: "transform")
        
        anim.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        anim.toValue = NSValue(caTransform3D: treed)
        anim.duration = 0.5
        view.layer.add(anim, forKey: nil)
        if view.subviews.count > 0 {
            for subview in view.subviews {
                animatied(subview)
            }
        }
    }
}

