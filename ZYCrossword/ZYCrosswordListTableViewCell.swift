//
//  ZYCrosswordListTableViewCell.swift
//  ZYCrossword
//
//  Created by MAC on 2017/7/7.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit

class ZYCrosswordListTableViewCell: UITableViewCell {
    @IBOutlet weak var crosswordDataLabel: UILabel!
    @IBOutlet weak var backroundImage: UIImageView!
    @IBOutlet weak var lineImae: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        backroundImage.image = backroundImage.image?.resizableImage(withCapInsets: UIEdgeInsetsMake(20, 10, 20, 10), resizingMode: UIImageResizingMode.stretch)
        lineImae.image = lineImae.image?.resizableImage(withCapInsets: UIEdgeInsetsMake(20, 0, 20, 0), resizingMode: UIImageResizingMode.stretch)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
