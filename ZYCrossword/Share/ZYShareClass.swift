//
//  ZYShareClass.swift
//  ZYCrossword
//
//  Created by 朱勇 on 2018/2/2.
//  Copyright © 2018年 ZhuYong. All rights reserved.
//

import UIKit

class ZYShareClass: NSObject {
    static let share = ZYShareClass()
    fileprivate override init() { }
    
    func showShareMenu(text: String, images: UIImage, url: URL, title: String, type: SSDKContentType, view: UIView) {
        //1.创建分享参数
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: text, images: images, url: url, title: title, type: type)
        //2.进行分享
        let sheet = ShareSDK.showShareActionSheet(view, items: nil, shareParams: shareParames) { (state : SSDKResponseState, platformType : SSDKPlatformType, userdata : [AnyHashable : Any]?, contentEnity : SSDKContentEntity?, error : Error?, end) in
            switch state{
                case SSDKResponseState.success:
                    print("分享成功")
                case SSDKResponseState.fail:
                    print("分享失败,错误描述:\(String(describing: error))")
                case SSDKResponseState.cancel:
                    print("分享取消")
            default:
                break
            }
        }
        sheet?.directSharePlatforms.add(SSDKPlatformType.typeSinaWeibo.rawValue)
        sheet?.directSharePlatforms.add(SSDKPlatformType.typeDouBan.rawValue)
        sheet?.directSharePlatforms.add(SSDKPlatformType.typeFacebook.rawValue)
        sheet?.directSharePlatforms.add(SSDKPlatformType.typeTwitter.rawValue)
        sheet?.directSharePlatforms.add(SSDKPlatformType.typeGooglePlus.rawValue)
        sheet?.directSharePlatforms.add(SSDKPlatformType.typeInstagram.rawValue)
    }
    func simpleShare(text: String, images: UIImage, url: URL, title: String, platformType: SSDKPlatformType) {
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: text, images: images, url: url, title: title, type: SSDKContentType.image)
        //2.进行分享
        ShareSDK.share(platformType, parameters: shareParames) { (state : SSDKResponseState, userData : [AnyHashable : Any]?, contentEntity :SSDKContentEntity?, error : Error?) -> Void in
            switch state{
                case SSDKResponseState.success:
                    print("分享成功")
                case SSDKResponseState.fail:
                    print("分享失败,错误描述:\(String(describing: error))")
                case SSDKResponseState.cancel:
                    print("分享取消")
                default:
                    break
            }
        }
    }
}
