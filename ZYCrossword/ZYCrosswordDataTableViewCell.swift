//
//  ZYCrosswordDataTableViewCell.swift
//  ZYCrossword
//
//  Created by MAC on 2017/6/14.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit

class ZYCrosswordDataTableViewCell: UITableViewCell {
    @IBOutlet weak var crosswordDataLabel: UILabel!
    @IBOutlet weak var moreFunctionButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var lineImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundImageView.image = backgroundImageView.image?.resizableImage(withCapInsets: UIEdgeInsetsMake(20, 10, 20, 10), resizingMode: UIImageResizingMode.stretch)
        lineImageView.theme_image = "rectangleLineImage"
        lineImageView.image = lineImageView.image?.resizableImage(withCapInsets: UIEdgeInsetsMake(20, 0, 20, 0), resizingMode: UIImageResizingMode.stretch)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
