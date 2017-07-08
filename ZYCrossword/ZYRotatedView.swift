//
//  ZYRotatedView.swift
//  
//
//  Created by MAC on 2017/7/7.
//
//

import UIKit

class ZYRotatedView: UIView, CAAnimationDelegate {
    var hiddenAfterAnimation: Bool?
    var backView: ZYRotatedView?
    
    func addBackView(with height: CGFloat, color: UIColor) {
        let view = ZYRotatedView(frame: .zero)
        view.backgroundColor = color
        view.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        view.layer.transform = rotateTransform3d()
        //禁用autoresizing
        view.translatesAutoresizingMaskIntoConstraints = false
        backView = view
        addSubview(view)
        //添加约束
        let viewConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: height)
        view.addConstraint(viewConstraint)
        addConstraints([NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: bounds.size.height - height + height / 2), NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0), NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)])
    }
    func rotatedX(by angle: CGFloat) {
        var allTransform = CATransform3DIdentity
        let rotateTransform = CATransform3DMakeRotation(angle, 1, 0, 0)
        //叠加效果
        allTransform = CATransform3DConcat(allTransform, rotateTransform)
        allTransform = CATransform3DConcat(allTransform, rotateTransform3d())
        layer.transform = allTransform
    }
    func foldingAnimation(with timing: String, from: CGFloat, to: CGFloat, duration: TimeInterval, delay: TimeInterval, hidden: Bool) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.x")
        rotateAnimation.timingFunction = CAMediaTimingFunction(name: timing)
        rotateAnimation.fromValue = [from]
        rotateAnimation.toValue = [to]
        rotateAnimation.duration = duration
        rotateAnimation.delegate = self
        rotateAnimation.fillMode = kCAFillModeForwards
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.beginTime = CACurrentMediaTime() + delay
        hiddenAfterAnimation = hidden
        layer.add(rotateAnimation, forKey: "rotation.x")
    }
    //MARK: - CAAnimationDelegate
    func animationDidStart(_ anim: CAAnimation) {
        //缓存layer为bitmap
        layer.shouldRasterize = true
        alpha = 1
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if hiddenAfterAnimation != nil {
            alpha = 0
        }
        layer.removeAllAnimations()
        layer.shouldRasterize = false
        rotatedX(by: 0)
    }
    func rotateTransform3d() -> CATransform3D {
        var transform = CATransform3DIdentity
        transform.m34 = 2.5 / -2000
        return transform
    }
    override func draw(_ rect: CGRect) {
        
    }
}
