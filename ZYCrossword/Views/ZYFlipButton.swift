//
//  ZYFlipButton.swift
//  ZYCrossword
//
//  Created by 朱勇 on 2017/10/30.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit

class ZYFlipButton: UIButton {
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        createLayers(image: UIImage())
        addTargets()
    }
    fileprivate var imageShape: CAShapeLayer!
    @IBInspectable open var image: UIImage! {
        didSet {
            createLayers(image: image)
        }
    }
    fileprivate let imageTransform = CAKeyframeAnimation(keyPath: "transform")
    fileprivate func createLayers(image: UIImage!) {
        self.layer.sublayers = nil
        
        let imageFrame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        let imgCenterPoint = CGPoint(x: imageFrame.midX, y: imageFrame.midY)
        // image layer
        imageShape = CAShapeLayer()
        imageShape.bounds = imageFrame
        imageShape.position = imgCenterPoint
        imageShape.path = UIBezierPath(rect: imageFrame).cgPath
        imageTransform.duration = 1.0
        imageShape.fillColor = UIColor(patternImage: image).cgColor
        imageShape.actions = ["fillColor": NSNull()]
        self.layer.addSublayer(imageShape)
        
        imageShape.mask = CALayer()
        imageShape.mask!.contents = image.cgImage
        imageShape.mask!.bounds = imageFrame
        imageShape.mask!.position = imgCenterPoint
        // image transform animation
        imageTransform.duration = 1.0 //0.0333 * 30
        imageTransform.values = [
            NSValue(caTransform3D: CATransform3DMakeScale(0.875,   0.875,   1.0)),  //  0/30
            NSValue(caTransform3D: CATransform3DMakeScale(0.9,   0.9,   1.0)),  //  3/30
            NSValue(caTransform3D: CATransform3DMakeScale(1.2,   1.2,   1.0)),  //  9/30
            NSValue(caTransform3D: CATransform3DMakeScale(1.25,  1.25,  1.0)),  // 10/30
            NSValue(caTransform3D: CATransform3DMakeScale(1.2,   1.2,   1.0)),  // 11/30
            NSValue(caTransform3D: CATransform3DMakeScale(0.9,   0.9,   1.0)),  // 14/30
            NSValue(caTransform3D: CATransform3DMakeScale(0.875, 0.875, 1.0)),  // 15/30
            NSValue(caTransform3D: CATransform3DMakeScale(0.875, 0.875, 1.0)),  // 16/30
            NSValue(caTransform3D: CATransform3DMakeScale(0.9,   0.9,   1.0)),  // 17/30
            NSValue(caTransform3D: CATransform3DMakeScale(1.01, 1.01, 1.0)),  // 20/30
            NSValue(caTransform3D: CATransform3DMakeScale(1.02, 1.02, 1.0)),  // 21/30
            NSValue(caTransform3D: CATransform3DMakeScale(1.01, 1.01, 1.0)),  // 22/30
            NSValue(caTransform3D: CATransform3DMakeScale(0.96,  0.96,  1.0)),  // 25/30
            NSValue(caTransform3D: CATransform3DMakeScale(0.95,  0.95,  1.0)),  // 26/30
            NSValue(caTransform3D: CATransform3DMakeScale(0.96,  0.96,  1.0)),  // 27/30
            NSValue(caTransform3D: CATransform3DMakeScale(0.99,  0.99,  1.0)),  // 29/30
            NSValue(caTransform3D: CATransform3DIdentity)                       // 30/30
        ]
        imageTransform.keyTimes = [
            0.0,    //  0/30
            0.1,    //  3/30
            0.3,    //  9/30
            0.333,  // 10/30
            0.367,  // 11/30
            0.467,  // 14/30
            0.5,    // 15/30
            0.533,  // 16/30
            0.567,  // 17/30
            0.667,  // 20/30
            0.7,    // 21/30
            0.733,  // 22/30
            0.833,  // 25/30
            0.867,  // 26/30
            0.9,    // 27/30
            0.967,  // 29/30
            1.0     // 30/30
        ]
    }
    fileprivate func addTargets() {
        //===============
        // add target
        //===============
        self.addTarget(self, action: #selector(ZYFlipButton.touchDown(_:)), for: UIControlEvents.touchDown)
        self.addTarget(self, action: #selector(ZYFlipButton.touchUpInside(_:)), for: UIControlEvents.touchUpInside)
        self.addTarget(self, action: #selector(ZYFlipButton.touchDragExit(_:)), for: UIControlEvents.touchDragExit)
        self.addTarget(self, action: #selector(ZYFlipButton.touchDragEnter(_:)), for: UIControlEvents.touchDragEnter)
        self.addTarget(self, action: #selector(ZYFlipButton.touchCancel(_:)), for: UIControlEvents.touchCancel)
    }
    @objc func touchDown(_ sender: ZYFlipButton) {
        self.layer.opacity = 0.4
    }
    @objc func touchUpInside(_ sender: ZYFlipButton) {
        self.layer.opacity = 1.0
    }
    @objc func touchDragExit(_ sender: ZYFlipButton) {
        self.layer.opacity = 1.0
    }
    @objc func touchDragEnter(_ sender: ZYFlipButton) {
        self.layer.opacity = 0.4
    }
    @objc func touchCancel(_ sender: ZYFlipButton) {
        self.layer.opacity = 1.0
    }
    open func select() {
        CATransaction.begin()
        imageShape.add(imageTransform, forKey: "transform")
        CATransaction.commit()
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
}
