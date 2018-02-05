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

public enum ZYShareType: Int {
    case WeiChat = 0
    case WeiChatCircle = 1
    case QQ = 2
    case QZone = 3
    case Sina = 4
    case Douban = 5
    case Facebook = 6
    case Twitter = 7
    case Instagram = 8
    case GooglePlus = 9
    
    static let allValues = [WeiChat,WeiChatCircle,QQ,QZone,Sina,Douban,Facebook,Twitter,Instagram,GooglePlus]
}
public class ZYTrickyShareView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        buildUI()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {// 释放当前window
        ZYTrickyTipsView.shareTrickyTipsView.bgWindows.removeLast()
    }
    
    //MARk: - 控件
    @objc func shareBtnClick(sender: UIButton) {// 分享按钮点击事件
        ZYScreenShotTools.shareScreenShotTools.shareView(self, didClickShareBtn: ZYShareType.init(rawValue: sender.tag)!, icon: shareIcon!)
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
    lazy var cancelBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("取消", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor(0xed5c4d), for: .normal)
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
        ZYTrickyTipsView.shareTrickyTipsView.bgWindows.append(window)
        let iconHeight = screenHeight - 70 - 16 - 30 - 120
        shareView.iconView.snp.makeConstraints { (make) in
            make.top.equalTo(shareView.titleLabel.snp.bottom).offset(16)
            make.centerX.equalTo(shareView)
            make.width.equalTo(iconHeight * screenWidth / screenHeight)
            make.height.equalTo(iconHeight)
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
        //MARK: shareButton
        let leftMargin :CGFloat = 20
        let sharH : CGFloat = 40
        let space =  (self.bounds.width - leftMargin * 2 - sharH * 5) / 4
        let line = UIView()
        line.backgroundColor = UIColor(0x8b8b8b)
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-(sharH * 2 + leftMargin * 2))
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
        for type in ZYShareType.allValues {
            let shareButton = IconButton()
            switch type {
            case .WeiChat:
                shareButton.setImage(UIImage(named: "wechat"), for: .normal)
            case .WeiChatCircle:
                shareButton.setImage(UIImage(named: "wechat_timeline"), for: .normal)
            case .QQ:
                shareButton.setImage(UIImage(named: "qq"), for: .normal)
            case .QZone:
                shareButton.setImage(UIImage(named: "qzone"), for: .normal)
            case .Sina:
                shareButton.setImage(UIImage(named: "sina"), for: .normal)
            case .Douban:
                shareButton.setImage(UIImage(named: "豆瓣"), for: .normal)
            case .Facebook:
                shareButton.setImage(UIImage(named: "facebook"), for: .normal)
            case .Twitter:
                shareButton.setImage(UIImage(named: "twitter"), for: .normal)
            case .Instagram:
                shareButton.setImage(UIImage(named: "instagram"), for: .normal)
            case .GooglePlus:
                shareButton.setImage(UIImage(named: "googlePlus"), for: .normal)
            }
            shareButton.tag = type.rawValue
            shareButton.addTarget(self, action: #selector(shareBtnClick(sender:)), for: .touchUpInside)
            addSubview(shareButton)
            shareButton.snp.makeConstraints({ (make) in
                make.height.equalTo(sharH)
                make.width.equalTo(sharH)
                make.top.equalTo(line.snp.bottom).offset((type.rawValue > 4) ? (sharH + leftMargin + 8) : leftMargin)
                make.left.equalTo(self).offset(leftMargin + CGFloat(type.rawValue % 5) * (space + sharH))
            })
        }
    }
}
