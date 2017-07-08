//
//  ZYCollectListTableViewCell.swift
//  ZYCrossword
//
//  Created by MAC on 2017/7/8.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit

class ZYCollectListTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func commonInit() {
        configureDefaultState()
        
    }
    func configureDefaultState() {
        
    }
    func createAnimationView() {
        
    }
    func addImageItemsToAnimationView() {
        
    }
    func removeImageItemsFromAnimationView() {
        
    }
//    func createAnimationItemView() -> [ZYRotatedView] {
//        
//    }
//    func configureAnimationItems(with animationType: AnimationType) {
//        
//    }
//    func selectedAnimation(by isSelected: Bool, completion: () -> Void) {
//        
//    }
//    func isAnimating() -> Bool {
//        
//    }
//    func animationDuration(with itemIndex: Int, type: AnimationType) -> TimeInterval {
//        
//    }
//    func durationSequence(with type: AnimationType) -> [NSNumber] {
//        
//    }
//    func openAnimation(with completion: () -> Void) {
//        
//    }
//    func closeAnimation(with completion: () -> Void) {
//        
//    }
}
public enum AnimationType: Int {
    case open = 0
    case close = 1
}
