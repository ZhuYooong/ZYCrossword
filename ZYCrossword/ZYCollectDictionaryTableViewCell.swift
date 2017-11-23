//
//  ZYCollectDictionaryTableViewCell.swift
//  ZYCrossword
//
//  Created by MAC on 2017/9/4.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import Material

class ZYCollectDictionaryTableViewCell: ZYFoldingTableViewCell {
    @IBOutlet weak var containerViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var containerBackgroundImageView: UIImageView!
    @IBOutlet weak var openTitleView: UIView!
    @IBOutlet weak var closeLineImageView: UIImageView!
    @IBOutlet weak var closeNameLabel: UILabel!
    @IBOutlet weak var openNameLabel: UILabel!
    @IBOutlet weak var closeTypeLabel: UILabel!
    @IBOutlet weak var openTypeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var detailButton: RaisedButton!
    var contentDic: [String: Any]? {
        didSet {
            closeNameLabel.text = contentDic?["name"] as? String
            openNameLabel.text = contentDic?["name"] as? String
            if isCollection {
                closeTypeLabel.text = contentDic?["type"] as? String
            }else {
                closeTypeLabel.text = "\(contentDic?["selecttedCount"] as? Int ?? 0) 次"
            }
            openTypeLabel.text = contentDic?["type"] as? String
            contentLabel.text = contentDic?["content"] as? String
        }
    }
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 8
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
        openTitleView.theme_backgroundColor = "inferiorColor"
        closeLineImageView.theme_image = "rectangleLineImage"
        containerBackgroundImageView.image = containerBackgroundImageView.image?.resizableImage(withCapInsets: UIEdgeInsetsMake(20, 10, 20, 10), resizingMode: UIImageResizingMode.stretch)
        detailButton.theme_backgroundColor = "buttonColor"
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
