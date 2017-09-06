//
//  ZYCollectDoubanTableViewCell.swift
//  ZYCrossword
//
//  Created by MAC on 2017/9/4.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit

class ZYCollectDoubanTableViewCell: ZYFoldingTableViewCell {
    @IBOutlet weak var containerViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var closeNameLabel: UILabel!
    @IBOutlet weak var closeDetailLabel: UILabel!
    @IBOutlet weak var closeTypeLabel: UILabel!
    @IBOutlet weak var openTypeLabel: UILabel!
    @IBOutlet weak var openNameLabel: UILabel!
    @IBOutlet weak var firstShortLabel: UILabel!
    @IBOutlet weak var secondShortLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 14
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }
    override func animationDuration(_ itemIndex: NSInteger, type: ZYFoldingTableViewCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2]
        return durations[itemIndex]
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
