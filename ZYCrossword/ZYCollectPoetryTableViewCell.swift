//
//  ZYCollectPoetryTableViewCell.swift
//  ZYCrossword
//
//  Created by MAC on 2017/9/4.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit

class ZYCollectPoetryTableViewCell: ZYFoldingTableViewCell {
    @IBOutlet weak var containerViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var containerBackgroundImageView: UIImageView!
    @IBOutlet weak var closeNameLabel: UILabel!
    @IBOutlet weak var closeDetailLabel: UILabel!
    @IBOutlet weak var closeTypeLabel: UILabel!
    @IBOutlet weak var openTypeLabel: UILabel!
    @IBOutlet weak var openNameLabel: UILabel!
    @IBOutlet weak var firstShortLabel: UILabel!
    @IBOutlet weak var secondShortLabel: UILabel!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var noteButton: UIButton!
    @IBOutlet weak var appreciateButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    var contentDic: [String: Any]? {
        didSet {
            closeNameLabel.text = contentDic?["name"] as? String
            openNameLabel.text = contentDic?["name"] as? String
            closeTypeLabel.text = contentDic?["type"] as? String
            openTypeLabel.text = contentDic?["type"] as? String
            contentLabel.text = contentDic?["content"] as? String
            closeDetailLabel.text = contentDic?["secondShort"] as? String
            firstShortLabel.text = contentDic?["firstShort"] as? String
            secondShortLabel.text = contentDic?["secondShort"] as? String
        }
    }
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 8
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
        containerBackgroundImageView.image = containerBackgroundImageView.image?.resizableImage(withCapInsets: UIEdgeInsetsMake(20, 10, 20, 10), resizingMode: UIImageResizingMode.stretch)
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
