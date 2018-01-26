//
//  ZYTrickyTipsView.swift
//  ZYCrossword
//
//  Created by 朱勇 on 2018/1/19.
//  Copyright © 2018年 ZhuYong. All rights reserved.
//

import UIKit
import Photos
import SnapKit
import Material

let tipSViewH :CGFloat  = 70.0

class ZYTrickyTipsView: UIWindow {
    var bgWindows : [UIWindow] = []
    open static let shared: ZYTrickyTipsView = {
        let instance = ZYTrickyTipsView()
        return instance
    }()
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: -tipSViewH, width: screenWidth, height: tipSViewH))
        buildUI()
    }
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: -tipSViewH, width: screenWidth, height: tipSViewH))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tipLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "已捕获屏幕截图"
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        return lbl
    }()
    lazy var bottomTips: UILabel = {
        let lbl = UILabel()
        lbl.text = "点击分享截图给朋友"
        lbl.textColor = UIColor(ZYCustomColor.textGray.rawValue)
        lbl.font = UIFont.systemFont(ofSize: 12)
        return lbl
    }()
    lazy var shareBtn: RaisedButton = {
        let btn = RaisedButton(title: "分享", titleColor: UIColor(0xffffff))
        btn.pulseColor = .white
        btn.theme_backgroundColor = "buttonColor"
        btn.addTarget(self, action: #selector(shareButtonClick), for: UIControlEvents.touchUpInside)
        return btn
    }()
    lazy var leftView: UIView = {
        let leftView = UIView()
        leftView.backgroundColor = .white
        leftView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleSwipeFrom(recognizer:))))
        return leftView
    }()
    lazy var rightView = UIView()
    
    var timer : Timer?
}
// MARK:UI搭建
extension ZYTrickyTipsView {
    func buildUI() {
        // UIWindowLevelStatusBar 是当前window遮盖statusBar
        self.windowLevel = UIWindowLevelStatusBar
        self.backgroundColor = UIColor.white
        
        rightView.backgroundColor = UIColor(0xed5c4d)
        addSubview(rightView)
        rightView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.height.equalTo(tipSViewH)
            make.width.equalTo(100)
        }
        rightView.addSubview(shareBtn)
        shareBtn.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(rightView)
        }
        addSubview(leftView)
        leftView.snp.makeConstraints { (make) in
            make.left.top.equalTo(self)
            make.height.equalTo(rightView)
            make.right.equalTo(rightView.snp.left)
        }
        leftView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.bottom.equalTo(leftView.snp.centerY).offset(-10)
            make.left.equalTo(leftView).offset(40)
            make.right.equalTo(leftView).offset(-10)
        }
        leftView.addSubview(bottomTips)
        bottomTips.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(tipLabel)
            make.top.equalTo(tipLabel.snp.bottom).offset(4)
        }
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor(0x808080)
        bottomLine.layer.cornerRadius = 1
        bottomLine.clipsToBounds = true
        addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.centerX.equalTo(self)
            make.height.equalTo(2)
            make.width.equalTo(50)
        }
    }
}
// MARK:事件响应
extension ZYTrickyTipsView {
    func showTips() {
        timer?.invalidate()
        timer = nil
        self.isHidden = false
        UIView.animate(withDuration: 1) {
            self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: tipSViewH)
        }
        timer = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(hiddenTips), userInfo: nil, repeats: false)
    }
    @objc func hiddenTips() {
        timer?.invalidate()
        timer = nil
        UIView.animate(withDuration: 1, animations: {
            self.frame = CGRect(x: 0, y: -tipSViewH, width: UIScreen.main.bounds.width, height: tipSViewH)
        }) { (stop) in
            self.isHidden = true
        }
    }
    @objc func handleSwipeFrom(recognizer:UIPanGestureRecognizer) {
        if recognizer.state == .cancelled || recognizer.state == .ended || recognizer.state == .failed{
            if center.y >= tipSViewH/2 {
                showTips()
            }else{
                hiddenTips()
            }
        }else{
            timer?.invalidate()
            timer = nil
            let translation = recognizer.translation(in: leftView)
            recognizer.setTranslation(CGPoint(x: 0, y: 0), in: leftView)
            let centY = center.y + translation.y
            if centY > tipSViewH/2 {
                recognizer.setTranslation(CGPoint(x: 0, y: 0), in: leftView)
                return
            }
            if centY < -tipSViewH/2 {
                return
            }
            self.center = CGPoint(x: center.x, y: centY)
        }
    }
    @objc func shareButtonClick() {
        self.isHidden = true
        self.frame = CGRect(x: 0, y: -tipSViewH, width: UIScreen.main.bounds.width, height: tipSViewH)
        if PhotoLibraryPermissions() == false {
            return
        }
        getNewPhoto { (icon) in
            if icon != nil{
                _ = ZYTrickyShareView.show(icon: icon)
            }
        }
    }
}
// MARK:相册相关
extension ZYTrickyTipsView {
    func openSetting() {
        if UIApplication.shared.canOpenURL(URL(string: UIApplicationOpenSettingsURLString)!) {
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        }
    }
    func openSetView() {
        // 判断上一次拒绝是多久之前。避免频繁弹窗用户反感 设置为30天后再次弹窗
        if UserDefaults.standard.bool(forKey: "TCScreenShotTools Would Like to Access Your Photos") {
            let lastDate = UserDefaults.standard.value(forKey: "TCScreenShotTools Would Like to Access Your Photos Time") as! NSDate
            if NSDate().timeIntervalSince1970 - lastDate.timeIntervalSince1970 < 30*24*60*60 {
                return
            }
        }
        let appName = Bundle.main.infoDictionary!["CFBundleName"] ?? "app"
        var title = "\"\(appName)\" Would Like to Access Your Photos"
        var cancelTitle = "Don't Allow"
        var okTitle = "OK"
        let currentLanguage = NSLocale.preferredLanguages.first ?? ""
        if currentLanguage.hasPrefix("zh-Han"){
            title = "\"\(appName)\"想访问您的照片"
            cancelTitle = "不允许"
            okTitle = "好"
        }
        let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.cancel, handler: { (_) in
            UserDefaults.standard.set(true, forKey: "TCScreenShotTools Would Like to Access Your Photos")
            UserDefaults.standard.set(NSDate(), forKey: "TCScreenShotTools Would Like to Access Your Photos Time")
            UserDefaults.standard.synchronize()
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: okTitle, style: UIAlertActionStyle.default, handler: {[weak self] (action) in
            UserDefaults.standard.set(false, forKey: "TCScreenShotTools Would Like to Access Your Photos")
            UserDefaults.standard.synchronize()
            self?.openSetting()
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    func PhotoLibraryPermissions() -> Bool {
        let library:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if(library == PHAuthorizationStatus.denied || library == PHAuthorizationStatus.restricted){
            openSetView()
            return false
        }else {
            return true
        }
    }
    func getNewPhoto(completion: @escaping (_ result:UIImage?) -> ()) -> () {
        // 申请权限
        PHPhotoLibrary.requestAuthorization { (status) in
            if status != .authorized {
                return
            }
            let smartOptions = PHFetchOptions()
            let collection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,subtype: .albumRegular, options: smartOptions)
            for i in 0 ..< collection.count{
                // 获取出但前相簿内的图片
                let resultsOptions = PHFetchOptions()
                resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                resultsOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
                let c = collection[i]
                let title = "Screenshots"
                if c.localizedTitle == title{
                    let assetsFetchResult = PHAsset.fetchAssets(in: c , options: resultsOptions)
                    if assetsFetchResult.count == 0{
                        completion(nil)
                    }else{
                        PHImageManager.default().requestImage(for: assetsFetchResult[0], targetSize: PHImageManagerMaximumSize , contentMode: .default, options: nil, resultHandler: { (image, _: [AnyHashable : Any]?) in
                            completion(image)
                        })
                    }
                }
            }
        }
    }
}
