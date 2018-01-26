//
//  ZYScreenShotTools.swift
//  ZYCrossword
//
//  Created by 朱勇 on 2018/1/19.
//  Copyright © 2018年 ZhuYong. All rights reserved.
//

import UIKit
public struct ZYPlatform {
    public static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}
public protocol ZYScreenShotToolsDelegate {
    func screenShotTools(_tools:ZYScreenShotTools, didClickShareBtn withShareType: ZYShareType, withIcon: UIImage ,in shareView: ZYTrickyShareView)
}
class ZYScreenShotTools: NSObject {
    public var delegate:ZYScreenShotToolsDelegate?
    /// 全局唯一实例
    public static let shared = ZYScreenShotTools()
    /// 监听截图事件开关
    public var enable = false {
        didSet {
            if enable == true &&
                oldValue == false {
                //添加监听事件
                NotificationCenter.default.addObserver(self, selector: #selector(screenShot), name: NSNotification.Name.UIApplicationUserDidTakeScreenshot, object: nil)
            }else if enable == false {
                NotificationCenter.default.removeObserver(self)
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
// MARK: - 响应事件
extension ZYScreenShotTools {
    func shareView(_ shareView: ZYTrickyShareView, didClickShareBtn withShareType: ZYShareType, withIcon: UIImage) {
        delegate?.screenShotTools(_tools: self, didClickShareBtn: withShareType, withIcon: withIcon, in: shareView)
    }
    func tipsShow(title:String?,message:String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    @objc func screenShot() {
        ZYTrickyShareView.shared.showTips()
    }
}
extension ZYScreenShotToolsDelegate {
    public func screenShotTools(_tools:ZYScreenShotTools, didClickShareBtn withShareType: ZYShareType, withIcon: UIImage ,in shareView: ZYTrickyShareView){}
}
