//
//  ZYTrickyShareView.swift
//  ZYCrossword
//
//  Created by 朱勇 on 2018/1/19.
//  Copyright © 2018年 ZhuYong. All rights reserved.
//

import UIKit
import SnapKit
import Material

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
class ZYTrickyShareView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        buildUI()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {// 释放当前window
        ZYTrickyTipsView.shared.bgWindows.removeLast()
    }
    
    //MARk: - 控件
    @objc func shareBtnClick(btn: UIButton) {// 分享按钮点击事件
        ZYScreenShotTools.shared.shareView(self, didClickShareBtn : ZYShareType.init(rawValue: btn.tag)!, withIcon: shareIcon!)
    }
    var shareIcon: UIImage? {
        didSet{
            iconView.image = shareIcon
        }
    }
    // MARK:懒加载控件
    lazy var sharetips: UILabel = {
        let lbl = UILabel()
        lbl.text = "分享到"
        lbl.backgroundColor = UIColor.white
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textColor = UIColor(ZYCustomColor.textBlack.rawValue)
        lbl.isHidden = true
        return lbl 
    }()
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "截屏分享"
        lbl.font = UIFont.boldSystemFont(ofSize: 30)
        lbl.textColor = UIColor.black
        lbl.sizeToFit()
        lbl.isHidden = true
        return lbl
    }()
    lazy var iconView = UIImageView(frame: UIScreen.main.bounds)
    lazy var cancelBtn: RaisedButton = {
        let btn = RaisedButton(title: "取消", titleColor: UIColor(0xed5c4d))
        btn.pulseColor = .white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        btn.sizeToFit()
        btn.isHidden = true
        return btn
    }()
    
    static func show(icon:UIImage?) {
        let shareView = ZYTrickyShareView(frame: UIScreen.main.bounds)
        shareView.shareIcon = icon
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = UIWindowLevelNormal
        window.backgroundColor = UIColor.black
        window.addSubview(shareView)
        window.isHidden = false
        ZYTrickyTipsView.shared.bgWindows.append(window)
        shareView.iconView.snp.makeConstraints { (make) in
            make.top.equalTo(shareView.titleLabel.snp.bottom).offset(16)
            make.centerX.equalTo(shareView)
            make.width.equalTo(shareView.bounds.width * 0.7)
            make.height.equalTo(shareView.bounds.height * 0.7)
        }
        UIView.animate(withDuration: 0.2, animations: {
            shareView.layoutIfNeeded()
        }) { (stop) in
            _ = shareView.subviews.map({ (subv) in
                subv.isHidden = false
            })
        }
    }
    // 关闭当前视图
 @objc func dismiss() {
        // 隐藏其他控件让IconView落到截图之前的View上，形成景深视觉效果
        _ = subviews.map { (subv) in subv.isHidden = subv != iconView }
        UIWindow.animate(withDuration: 0.2, animations: {
            self.iconView.frame = UIScreen.main.bounds
        }) { (stop) in
            self.removeFromSuperview()
        }
    }
}
// MARK: - UI搭建
extension ZYTrickyShareView {
    func buildUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self.snp.top).offset(70)
        }
        addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(titleLabel)
            make.right.equalTo(self).offset(-30)
        }
        iconView.backgroundColor = .gray
        addSubview(iconView)
        let line = UIView()
        line.backgroundColor = UIColor(0x8b8b8b)
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel.snp.bottom).offset(50 + bounds.height * 0.7)
            make.left.equalTo(self).offset(30)
            make.right.equalTo(self).offset(-30)
            make.height.equalTo(1)
        }
        addSubview(sharetips)
        sharetips.snp.makeConstraints { (make) in
            make.centerY.equalTo(line)
            make.centerX.equalTo(self)
            make.width.equalTo(80)
        }
        //MARK: shareButton
        let leftMargin :CGFloat = 20
        let sharH : CGFloat = 40
        let space =  (self.bounds.width - leftMargin * 2 - sharH * 5) / 4
        let sharebottomView = UIScrollView()
        sharebottomView.backgroundColor = .white
        addSubview(sharebottomView)
        sharebottomView.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(20)
            make.left.equalTo(self).offset(leftMargin)
            make.right.equalTo(self).offset(-leftMargin)
            make.height.equalTo(sharH)
        }
        for type in ZYShareType.allValues {
            let shareButton = ZYShareButton()
            switch type {
            case .WeiChat:
                shareButton.setContent(imageNamed: "")
            case .WeiChatCircle:
                shareButton.setContent(imageNamed: "")
            case .QQ:
                shareButton.setContent(imageNamed: "")
            case .QZone:
                shareButton.setContent(imageNamed: "")
            case .Sina:
                shareButton.setContent(imageNamed: "")
            case .Zhiu:
                shareButton.setContent(imageNamed: "")
            case .Douban:
                shareButton.setContent(imageNamed: "")
            }
            shareButton.setContent(title: type.rawValue, shareType: type)
            shareButton.addTarget(self, action: #selector(buttonDidClick(sender:)), for: .touchUpInside)
            bottomView?.addSubview(shareButton)
            shareButton.snp.makeConstraints({ (make) in
                make.height.equalTo(ZYScreenshotsTools.share.setAdaptation(fixedValue: 70, isHeight: true))
                make.width.equalTo(ZYScreenshotsTools.share.setAdaptation(fixedValue: 58, isHeight: false))
                make.top.equalTo(bottomView!).offset((type.hashValue > 3) ? ZYScreenshotsTools.share.setAdaptation(fixedValue: 70, isHeight: true) : 0)
                make.left.equalTo(bottomView!).offset(CGFloat(type.hashValue % 3) * ZYScreenshotsTools.share.setAdaptation(fixedValue: 58, isHeight: false))
            })
        }
    }
}
