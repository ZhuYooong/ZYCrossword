//
//  ZYScreenshotsPopView.swift
//  ZYCrossword
//
//  Created by 朱勇 on 2018/1/9.
//  Copyright © 2018年 ZhuYong. All rights reserved.
//

import UIKit
import SnapKit

class ZYScreenshotsPopView: UIView {
    var selectSheetBlock:((ZYShareType) -> Void)?
    var hiddenBlock:(() -> Void)?
    convenience init(shotsImage: UIImage, selectSheetBlock: @escaping ((ZYShareType) -> Void)){
        self.init()
        self.shotsImage = shotsImage
        self.selectSheetBlock = selectSheetBlock
    }
    var screenshotsMaskView: UIButton? {
        didSet {
            screenshotsMaskView = UIButton(type: .custom)
            screenshotsMaskView?.frame = UIScreen.main.bounds
            screenshotsMaskView?.backgroundColor = .black
            screenshotsMaskView?.addTarget(self, action: #selector(hiddenView), for: .touchUpInside)
        }
    }
    var shotsImage = UIImage()
    let shotsImageView = UIImageView()
    var bottomView: UIView? {
        didSet {
            bottomView = UIView()
            bottomView?.layer.masksToBounds = true
            bottomView?.layer.cornerRadius = 8
            bottomView?.backgroundColor = UIColor(0xEBEBEB)
        }
    }
    func show() {
        addSubview(screenshotsMaskView!)
        shotsImageView.image = shotsImage
        addSubview(shotsImageView)
        shotsImageView.snp.makeConstraints { (make) in
            make.height.equalTo(ZYScreenshotsTools.share.setAdaptation(fixedValue: 405, isHeight: true))
            make.width.equalTo(ZYScreenshotsTools.share.setAdaptation(fixedValue: 227, isHeight: false))
            make.top.equalTo(self).offset(ZYScreenshotsTools.share.setAdaptation(fixedValue: 22, isHeight: true))
            make.centerX.equalTo(self)
        }
        addSubview(bottomView!)
        bottomView?.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.height.equalTo(ZYScreenshotsTools.share.setAdaptation(fixedValue: 230, isHeight: true))
            make.top.equalTo(self.snp.bottom)
        }
        
        layoutBottomSubViews()
        animation(view: self, duration: 0.3)
        
        screenshotsMaskView?.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.screenshotsMaskView?.alpha = 0.5
        }
        UIView.animate(withDuration: 0.6) {
            self.bottomView?.snp.updateConstraints({ (make) in
                make.top.equalTo(self.snp.bottom).offset(-ZYScreenshotsTools.share.setAdaptation(fixedValue: 230, isHeight: true))
            })
        }
    }
    @objc func hiddenView() {
        UIView.animate(withDuration: 0.5) {
            self.shotsImageView.snp.updateConstraints { (make) in
                make.top.equalTo(self).offset(ZYScreenshotsTools.share.setAdaptation(fixedValue: 120, isHeight: true))
            }
            self.screenshotsMaskView?.alpha = 0.0
            self.bottomView?.alpha=0.0
            self.shotsImageView.alpha=0.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.screenshotsMaskView?.removeFromSuperview()
            self.removeFromSuperview()
            if self.hiddenBlock != nil {
                self.hiddenBlock!()
            }
        }
    }
    //MARK: - 添加底部视图的子视图
    func layoutBottomSubViews() {
        let titleLabel = UILabel()
        titleLabel.text = "截图分享到"
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: ZYScreenshotsTools.share.setAdaptationFont(fixedValue: 18))
        titleLabel.textAlignment = .center
        bottomView?.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.left.equalTo(bottomView!)
            make.height.equalTo(ZYScreenshotsTools.share.setAdaptation(fixedValue: 40, isHeight: true))
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
        
        let cancelButton = UIButton()
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.addTarget(self, action: #selector(hiddenView), for: .touchUpInside)
        cancelButton.backgroundColor = .white
        bottomView?.addSubview(cancelButton)
        cancelButton.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalTo(bottomView!)
            make.height.equalTo(ZYScreenshotsTools.share.setAdaptation(fixedValue: 40, isHeight: true))
        })
    }
    @objc func buttonDidClick(sender: ZYShareButton) {
        if self.selectSheetBlock != nil {
            self.selectSheetBlock!(sender.type)
        }
        hiddenView()
    }
    func animation(view: UIView, duration: CFTimeInterval) {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.values = [NSValue(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0)), NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1.0)), NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0))]
        animation.timingFunction = CAMediaTimingFunction(name: "easeInEaseOut")
        view.layer.add(animation, forKey: nil)
    }
}
class ZYScreenshotsTools: NSObject {
    static let share = ZYScreenshotsTools()
    fileprivate override init() {}
    
    func setAdaptation(fixedValue: CGFloat, isHeight: Bool) -> CGFloat {
        if isHeight {
            return fixedValue / 667.0 * screenHeight
        }else {
            return fixedValue / 375.0 * screenWidth
        }
    }
    func setAdaptationFont(fixedValue: CGFloat) -> CGFloat {
        return (((Double(UIDevice.current.systemVersion) ?? 0 >= 10.0) ? (true) : (false)) ? ((fixedValue - 1) * (screenWidth / 375.0)) : (fixedValue * (screenWidth / 375.0)))
    }
}

