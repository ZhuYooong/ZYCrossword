//
//  ZYMaterialDesignClass.swift
//  ZYCrossword
//
//  Created by MAC on 2017/6/9.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
let UIViewMaterialDesignTransitionDurationCoeff = 0.65
class ZYMaterialDesignClass: NSObject {

}
extension UIView {
    //MARK: - public methods
    func mdInflateTransition(from fromView: UIView, toView: UIView, originalPoint: CGPoint, duration: TimeInterval, completion block: @escaping () -> Void) {
        if let containerView = fromView.superview {
            let convertedPoint = fromView.convert(originalPoint, from: fromView)
            containerView.layer.masksToBounds = true
            containerView.mdAnimate(at: convertedPoint, backgroundColor: toView.backgroundColor!, duration: duration * UIViewMaterialDesignTransitionDurationCoeff, inflating: true, zTopPosition: true, shapeLayer: nil, completion: { 
                toView.alpha = 0.0
                toView.frame = fromView.frame
                containerView.addSubview(toView)
                fromView.removeFromSuperview()
                let animationDuration = TimeInterval(duration - duration * UIViewMaterialDesignTransitionDurationCoeff)
                UIView.animate(withDuration: animationDuration, animations: { 
                    toView.alpha = 1.0
                }, completion: { (finished) in
                    block()
                })
            })
        }else {
            block()
        }
    }
    func mdDeflateTransition(from fromView: UIView, toView: UIView, originalPoint: CGPoint, duration: TimeInterval, completion block: @escaping () -> Void) {
        if let containerView = fromView.superview {
            containerView.insertSubview(toView, belowSubview: fromView)
            toView.frame = fromView.frame
            let convertedPoint = toView.convert(originalPoint, from: fromView)
            let layer = toView.mdShapeLayerForAnimation(at: convertedPoint)
            layer.fillColor = fromView.backgroundColor?.cgColor
            toView.layer.addSublayer(layer)
            toView.layer.masksToBounds = true;
            let animationDuration = TimeInterval(duration - duration * UIViewMaterialDesignTransitionDurationCoeff)
            UIView.animate(withDuration: animationDuration, animations: {
                toView.alpha = 1.0
            }, completion: { (finished) in
                toView.mdAnimate(at: convertedPoint, backgroundColor: fromView.backgroundColor!, duration: duration * UIViewMaterialDesignTransitionDurationCoeff, inflating: false, zTopPosition: true, shapeLayer: layer, completion: {
                    block()
                })
            })
        }else {
            block()
        }
    }
    func mdInflateAnimated(from point: CGPoint, backgroundColor: UIColor, duration: TimeInterval, completion block: @escaping () -> Void) {
        mdAnimate(at: point, backgroundColor: backgroundColor, duration: duration, inflating: true, zTopPosition: false, shapeLayer: nil, completion: block)
    }
    func mdDeflateAnimated(from point: CGPoint, backgroundColor: UIColor, duration: TimeInterval, completion block: @escaping () -> Void) {
        mdAnimate(at: point, backgroundColor: backgroundColor, duration: duration, inflating: false, zTopPosition: false, shapeLayer: nil, completion: block)
    }
    //MARK: - helpers
    func mdShapeDiameter(for point: CGPoint) -> CGFloat {
        let cornerPoints = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: self.bounds.size.height), CGPoint(x: self.bounds.size.width, y: self.bounds.size.height), CGPoint(x: self.bounds.size.width, y: 0.0)]
        var radius: CGFloat = 0.0
        for p in cornerPoints {
            let d = sqrt(pow(p.x - point.x, 2.0) + pow(p.y - point.y, 2.0))
            if d > radius {
                radius = d
            }
        }
        return radius * 2.0
    }
    func mdShapeLayerForAnimation(at point: CGPoint) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        let diameter = mdShapeDiameter(for: point)
        shapeLayer.frame = CGRect(x: floor(point.x - diameter * 0.5), y: floor(point.y - diameter * 0.5), width: diameter, height: diameter)
        shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: 0.0, y: 0.0, width: diameter, height: diameter)).cgPath
        return shapeLayer
    }
    func shapeAnimation(with timingFunction: CAMediaTimingFunction, scale: CGFloat, inflating: Bool) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform")
        if inflating {
            animation.toValue = CATransform3DMakeScale(1.0, 1.0, 1.0)
            animation.fromValue = CATransform3DMakeScale(scale, scale, 1.0)
        }else {
            animation.toValue = CATransform3DMakeScale(scale, scale, 1.0)
            animation.fromValue = CATransform3DMakeScale(1.0, 1.0, 1.0)
        }
        animation.timingFunction = timingFunction
        animation.isRemovedOnCompletion = true
        return animation
    }
    //MARK: - animation
    func mdAnimate(at point: CGPoint, backgroundColor: UIColor, duration: TimeInterval, inflating: Bool, zTopPosition: Bool, shapeLayer: CAShapeLayer?, completion block: @escaping () -> Void) {
        if let shapeLayer = shapeLayer {
            let shapeLayer = mdShapeLayerForAnimation(at: point)
            self.layer.masksToBounds = true
        }
    }
}
