//
//  ZYLibraryListCell.swift
//  ZYCrossword
//
//  Created by MAC on 2017/9/19.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//
import TisprCardStack
import UIKit

class ZYLibraryListCell: TisprCardStackViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 12
        clipsToBounds = false
    }
    override var center: CGPoint {
        didSet {
            updateSmileVote()
        }
    }
    override internal func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        updateSmileVote()
    }
    func updateSmileVote() {
        
    }
}
