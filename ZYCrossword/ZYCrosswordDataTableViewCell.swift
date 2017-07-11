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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
