//
//  ZYScreenshotsPopView.swift
//  ZYCrossword
//
//  Created by 朱勇 on 2018/1/9.
//  Copyright © 2018年 ZhuYong. All rights reserved.
//

import UIKit

class ZYScreenshotsPopView: UIView {
    var screenshotsMaskView: UIButton? {
        didSet {
            screenshotsMaskView = UIButton(type: .custom)
            screenshotsMaskView?.frame = UIScreen.main.bounds
            screenshotsMaskView?.backgroundColor = .black
            screenshotsMaskView?.addTarget(self, action: #selector(hiddenView), for: .touchUpInside)
        }
    }
    let shotsImageView = UIImageView()
    var bottomView: UIView? {
        didSet {
            bottomView = UIView()
            bottomView?.backgroundColor = UIColor()
        }
    }
    @objc func hiddenView() {
        
    }
}
public enum ZYShareType: String {
    case WeiChat = "微信"
    case WeiChatCircle = "朋友圈"
    case QQ = "QQ"
    case QZone = "QQ空间"
    case Sina = "新浪微博"
    case Zhiu = "知乎"
    case Douban = "豆瓣"
    
    static let allValues = [WeiChat,WeiChatCircle,QQ,QZone,Sina,Zhiu,Douban]
}
