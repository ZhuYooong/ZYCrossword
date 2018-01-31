//
//  ZYScreenShotTools.swift
//  ZYCrossword
//
//  Created by 朱勇 on 2018/1/19.
//  Copyright © 2018年 ZhuYong. All rights reserved.
//

import UIKit

public protocol ZYScreenShotToolsDelegate {
    func screenShotTools(_ tools: ZYScreenShotTools, didClickShareBtn shareType: ZYShareType, icon: UIImage ,shareView: ZYTrickyShareView)
}
public class ZYScreenShotTools: NSObject {
    static let shareScreenShotTools = ZYScreenShotTools()
    fileprivate override init() { }
    
    public var delegate:ZYScreenShotToolsDelegate?
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
    func shareView(_ shareView: ZYTrickyShareView, didClickShareBtn shareType: ZYShareType, icon: UIImage) {
        delegate?.screenShotTools(self, didClickShareBtn: shareType, icon: icon, shareView: shareView)
    }
    func tipsShow(title:String?,message:String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    @objc func screenShot() {
        ZYTrickyTipsView.shareTrickyTipsView.showTips()
    }
}
extension ZYScreenShotToolsDelegate {
    public func screenShotTools(_ tools: ZYScreenShotTools, didClickShareBtn shareType: ZYShareType, icon: UIImage ,shareView: ZYTrickyShareView) {
        
    }
}
