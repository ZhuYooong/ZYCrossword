//
//  ZYLabraryCardTableViewCell.swift
//  ZYCrossword
//
//  Created by MAC on 2017/9/20.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit

class ZYLabraryCardTableViewCell: UITableViewCell {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var libraryContentButton: UIButton!
    @IBOutlet weak var lockImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addAnimationPath()
    }
    var layerRight = CAShapeLayer()
    var layerLine = CAShapeLayer()
    func addAnimationPath() {
        let width = Double(contentView.bounds.size.height)
        let pathRight = UIBezierPath()
        let pointOrigin = CGPoint(x: width / 2 - (width / 2) * cos(.pi / 8) + 4, y: width / 2 - (width / 2) * sin(.pi / 8))
        pathRight.move(to: pointOrigin)
        let pointTurn = CGPoint(x: width / 2 - (width / 4) * sin(.pi / 6), y: width / 2 + (width / 4) * cos(.pi / 6))
        pathRight.addLine(to: pointTurn)
        let pointEnd = CGPoint(x: width / 2 + (width * 3 / 7) * cos(.pi / 4), y: width / 2 - (width * 3 / 7) * sin(.pi / 4))
        pathRight.addLine(to: pointEnd)
        let colorView = UIView()
        colorView.theme_backgroundColor = "mainColor"
        layerRight.strokeColor = colorView.backgroundColor?.cgColor
        layerRight.fillColor = UIColor.clear.cgColor
        layerRight.lineWidth = 10
        layerRight.path = pathRight.cgPath
        
        let pathLine = UIBezierPath()
        let poinLinetOrigin = CGPoint(x: width / 2 - (width / 2) * cos(.pi / 8) + 4, y: width / 2 - (width / 2) * sin(.pi / 8))
        pathLine.move(to: poinLinetOrigin)
        let pointLineEnd = CGPoint(x: width / 4 - 3, y: width / 2)
        pathLine.addLine(to: pointLineEnd)
        layerLine.fillColor = UIColor.clear.cgColor
        layerLine.strokeColor = UIColor.white.cgColor
        layerLine.lineWidth = 12
        layerLine.path = pathLine.cgPath
    }
    open var isCollectionSelected: Bool = false
    open var isCollection: Bool = false {
        didSet {
            if isCollectionSelected {
                isUserInteractionEnabled = false
                if isCollection {
                    startRightAnimation(with: NSNumber(value: 0), and: NSNumber(value: 1))
                }else {
                    startLineAnimation(with: NSNumber(value: 1), and: NSNumber(value: 0))
                    startRightAnimation(with: NSNumber(value: 1), and: NSNumber(value: 0))
                }
                isCollectionSelected = false
            }
        }
    }
    func startRightAnimation(with fromValue: NSNumber, and endValue: NSNumber) {
        let animationRight = CABasicAnimation(keyPath: "strokeEnd")
        animationRight.delegate = self
        animationRight.fromValue = fromValue
        animationRight.toValue = endValue
        animationRight.duration = 1
        animationRight.isRemovedOnCompletion = false
        layerRight.add(animationRight, forKey: "right")
        backgroundImageView.layer.addSublayer(layerRight)
    }
    func startLineAnimation(with fromValue: NSNumber, and endValue: NSNumber) {
        let animationRight = CABasicAnimation(keyPath: "strokeEnd")
        animationRight.delegate = self
        animationRight.fromValue = fromValue
        animationRight.toValue = endValue
        animationRight.duration = 0.2
        animationRight.isRemovedOnCompletion = false
        layerLine.add(animationRight, forKey: "line")
        backgroundImageView.layer.addSublayer(layerLine)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
extension ZYLabraryCardTableViewCell: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if isCollection {
            if anim.duration == 1 {
                startLineAnimation(with: NSNumber(value: 0), and: NSNumber(value: 1))
            }
            if anim.duration == 0.2 {
                isUserInteractionEnabled = true
            }
        }else {
            if anim.duration == 0.2 {
                layerLine.removeFromSuperlayer()
            }
            if anim.duration == 1 {
                layerRight.removeFromSuperlayer()
                isUserInteractionEnabled = true
            }
        }
    }
}
