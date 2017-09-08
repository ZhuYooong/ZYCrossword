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
    var contentDic: [String: String]? {
        didSet {
            closeNameLabel.text = contentDic?["name"]
            openNameLabel.text = contentDic?["name"]
            detailButton.setTitle(contentDic?["name"], for: .normal)
            closeTypeLabel.text = contentDic?["type"]
            openTypeLabel.text = contentDic?["type"]
            contentLabel.text = contentDic?["content"]
            closeDetailLabel.text = contentDic?["secondShort"]
            firstShortLabel.text = contentDic?["firstShort"]
            secondShortLabel.text = contentDic?["secondShort"]
            longLabel.text = contentDic?["long"]
        }
    }
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
