//
//  ZYLabraryCardTableViewCell.swift
//  ZYCrossword
//
//  Created by MAC on 2017/9/20.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit

class ZYLabraryCardTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
