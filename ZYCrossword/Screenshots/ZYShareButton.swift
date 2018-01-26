//
//  ZYShareButton.swift
//  ZYCrossword
//
//  Created by 朱勇 on 2018/1/10.
//  Copyright © 2018年 ZhuYong. All rights reserved.
//

import UIKit

class ZYShareButton: UIButton {
    func setContent(imageNamed: String) {
        self.titleLabel?.font = UIFont.systemFont(ofSize: ZYScreenshotsTools.share.setAdaptationFont(fixedValue: 14))
        self.setTitleColor(.gray, for: .normal)
        self.titleLabel?.textAlignment = .center
        self.titleRect = CGRect(x: 0, y: ZYScreenshotsTools.share.setAdaptation(fixedValue: 58, isHeight: false), width: ZYScreenshotsTools.share.setAdaptation(fixedValue: 58, isHeight: false), height: ZYScreenshotsTools.share.setAdaptation(fixedValue: 70, isHeight: true) - ZYScreenshotsTools.share.setAdaptation(fixedValue: 58, isHeight: false))
        self.setImage(UIImage(named: imageNamed), for: .normal)
        self.imageRect = CGRect(x: ZYScreenshotsTools.share.setAdaptation(fixedValue: 4, isHeight: false), y: ZYScreenshotsTools.share.setAdaptation(fixedValue: 4, isHeight: false), width: ZYScreenshotsTools.share.setAdaptation(fixedValue: 50, isHeight: false), height: ZYScreenshotsTools.share.setAdaptation(fixedValue: 50, isHeight: false))
    }
    var type = ZYShareType.QQ
    func setContent(title: String, shareType: ZYShareType) {
        self.setTitle(title, for: .normal)
        self.type = shareType
    }
    var titleRect: CGRect?
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        if let rect = titleRect {
            return rect
        }
        return super.titleRect(forContentRect: contentRect)
    }
    var imageRect: CGRect?
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        if let rect = imageRect {
            return rect
        }
        return super.imageRect(forContentRect: contentRect)
    }
}
