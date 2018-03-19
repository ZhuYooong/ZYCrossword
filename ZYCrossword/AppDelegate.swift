//
//  AppDelegate.swift
//  ZYCrossword
//
//  Created by MAC on 2017/4/25.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import RealmSwift
import Material
import SwiftTheme
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setRealmData()
        if let themeName = ZYSecretClass.shareSecret.getUserDefaults(with: themeKey) {
            ThemeManager.setTheme(plistName: themeName, path: .mainBundle)
        }else {
            ThemeManager.setTheme(plistName: "Cyan", path: .mainBundle)
        }
        ZYScreenShotTools.shareScreenShotTools.enable = true
        ZYScreenShotTools.shareScreenShotTools.delegate = self
        registeShareSDK()
        GADMobileAds.configure(withApplicationID: "YOUR_ADMOB_APP_ID")
        window = UIWindow(frame: Screen.bounds)
        let navigationBar = UINavigationBar.appearance()
        navigationBar.theme_barTintColor = "mainColor"
        window!.makeKeyAndVisible()
        setRootController()
        return true
    }
    //MARK: Realm
    func setRealmData() {
        realmSchemaVersion()
        
        DispatchQueue(label: "loadBaseWord").async {
            ZYWordViewModel.shareWord.initFirstData()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: baseWordKey), object: nil)
        }
    }
    let schemaVersion: UInt64 = 1
    func realmSchemaVersion() {
        let config = Realm.Configuration(
            schemaVersion: schemaVersion,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < self.schemaVersion) { }
        })
        Realm.Configuration.defaultConfiguration = config
    }
    //MARK: ShareSDK
    func registeShareSDK() {
        ShareSDK.registerActivePlatforms(
            [SSDKPlatformType.typeWechat.rawValue,
             SSDKPlatformType.typeQQ.rawValue,
             SSDKPlatformType.typeSinaWeibo.rawValue,
             SSDKPlatformType.typeDouBan.rawValue,
             SSDKPlatformType.typeFacebook.rawValue,
             SSDKPlatformType.typeTwitter.rawValue,
             SSDKPlatformType.typeInstagram.rawValue,
             SSDKPlatformType.typeGooglePlus.rawValue],
            onImport: {(platform : SSDKPlatformType) -> Void in
                switch platform {
                case SSDKPlatformType.typeSinaWeibo:
                    ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                case SSDKPlatformType.typeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                case SSDKPlatformType.typeQQ:
                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                default:
                    break
                }
        }, onConfiguration: {(platform : SSDKPlatformType, appInfo : NSMutableDictionary?) -> Void in
                switch platform {
                case SSDKPlatformType.typeSinaWeibo:
                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                    appInfo?.ssdkSetupSinaWeibo(byAppKey: "568898243", appSecret: "38a4f8204cc784f81f9f0daaf31e02e3", redirectUri: "http://www.sharesdk.cn", authType: SSDKAuthTypeBoth)
                case SSDKPlatformType.typeWechat:
                    //设置微信应用信息
                    appInfo?.ssdkSetupWeChat(byAppId: "wx4868b35061f87885", appSecret: "64020361b8ec4c99936c0e3999a9f249")
                case SSDKPlatformType.typeQQ:
                    //设置QQ应用信息
                    appInfo?.ssdkSetupQQ(byAppId: "100371282", appKey: "aed9b0303e3ed1e27bae87c33761161d", authType: SSDKAuthTypeWeb)
                case SSDKPlatformType.typeFacebook:
                    //设置Facebook应用信息，其中authType设置为只用SSO形式授权
                    appInfo?.ssdkSetupFacebook(byApiKey: "107704292745179", appSecret: "38053202e1a5fe26c80c753071f0b573", displayName: "ShareSDK", authType: SSDKAuthTypeBoth)
                case SSDKPlatformType.typeTwitter:
                    //设置Twitter应用信息
                    appInfo?.ssdkSetupTwitter(byConsumerKey: "LRBM0H75rWrU9gNHvlEAA2aOy", consumerSecret: "gbeWsZvA9ELJSdoBzJ5oLKX0TU09UOwrzdGfo9Tg7DjyGuMe8G", redirectUri: "http://mob.com")
                case SSDKPlatformType.typeDouBan:
                    //设置豆瓣应用信息
                    appInfo?.ssdkSetupDouBan(byApiKey: "02e2cbe5ca06de5908a863b15e149b0b", secret: "9f1e7b4f71304f2f", redirectUri: "http://www.sharesdk.cn")
                case SSDKPlatformType.typeInstagram:
                    //设置Instagram应用信息
                    appInfo?.ssdkSetupInstagram(byClientID: "ff68e3216b4f4f989121aa1c2962d058", clientSecret: "1b2e82f110264869b3505c3fe34e31a1", redirectUri: "http://sharesdk.cn")
                default:
                    break
                }
        })
    }
    //MARK: 跳转页面
    func setRootController() {
        // 得到当前应用的版本号
        let infoDictionary = Bundle.main.infoDictionary
        let currentAppVersion = infoDictionary!["CFBundleShortVersionString"] as! String
        // 取出之前保存的版本号
        let userDefaults = UserDefaults.standard
        let appVersion = userDefaults.string(forKey: "appVersion")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // 如果 appVersion 为 nil 说明是第一次启动；如果 appVersion 不等于 currentAppVersion 说明是更新了
        if appVersion == nil || appVersion != currentAppVersion {
            // 保存最新的版本号
            userDefaults.setValue(currentAppVersion, forKey: "appVersion")
            let guideViewController = storyboard.instantiateViewController(withIdentifier: "GuideViewController") as! ZYGuideViewController
            guideViewController.startAnimateBlock = { isStart in
                if isStart {
                    self.initAnimation()
                }
            }
            window?.rootViewController = guideViewController
        }else {
            initAnimation()
        }
    }
    func initAnimation() {
        window?.rootViewController = SnackbarController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainID"))
        
        let backgroupView = UIView.init(frame: (window?.bounds)!)
        backgroupView.backgroundColor = UIColor.black
        window?.addSubview(backgroupView)
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: (window?.bounds.width)!, height: (window?.bounds.height)!))
        imageView.image = getImageFromView(view: (window?.rootViewController?.view)!)
        window?.addSubview(imageView)
        
        let maskLayer = CALayer()
        maskLayer.contents = UIImage.init(named:"图标")?.cgImage
        maskLayer.position = (window?.center)!
        maskLayer.bounds = CGRect(x: 0, y: 0, width: 60,height: 60)
        imageView.layer.mask = maskLayer
        
        let maskBackgroudView = UIView.init(frame: (imageView.bounds))
        maskBackgroudView.backgroundColor = UIColor.white
        imageView.addSubview(maskBackgroudView)
        imageView.bringSubview(toFront: maskBackgroudView)
        
        let logoMaskAnimation = CAKeyframeAnimation.init(keyPath: "bounds")
        logoMaskAnimation.duration = 1.0
        
        let initalBounds = maskLayer.bounds
        let secondBounds = CGRect(x:0,y:0,width:30,height:30)
        let finalBounds = CGRect(x:0,y:0,width:2000,height:2000)
        
        logoMaskAnimation.values = [NSValue (cgRect: initalBounds),NSValue (cgRect: secondBounds),NSValue (cgRect: finalBounds)]
        logoMaskAnimation.keyTimes = [0,0.5,1]
        logoMaskAnimation.timingFunctions =  [CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut),CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut),CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)]
        logoMaskAnimation.isRemovedOnCompletion = false
        logoMaskAnimation.beginTime = CACurrentMediaTime() + 1.0
        logoMaskAnimation.fillMode = kCAFillModeForwards
        imageView.layer.mask?.add(logoMaskAnimation, forKey: "logoMaskAnimation")
        
        UIView.animate(withDuration: 0.5, delay: 1.35, options: UIViewAnimationOptions.curveEaseIn, animations: {()-> Void in
            maskBackgroudView.alpha = 0.0;
        }, completion: {(finished) -> Void in
            maskBackgroudView.removeFromSuperview()
        })
        UIView.animate(withDuration: 0.5, delay: 1, options: UIViewAnimationOptions.transitionCurlUp, animations: {
            ()-> Void in
            imageView.transform = CGAffineTransform (scaleX: 1.1, y: 1.1)
        }, completion: {(finished) -> Void in
            UIView .animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {()-> Void in
                imageView.transform = CGAffineTransform .identity;
            }, completion: {(finished) -> Void in
                imageView.removeFromSuperview()
                backgroupView.removeFromSuperview()
            })
        })
    }
    func getImageFromView(view:UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    //MARK: 生命周期
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
extension AppDelegate: ZYScreenShotToolsDelegate {
    func screenShotTools(_ tools: ZYScreenShotTools, didClickShareBtn shareType: ZYShareType, icon: UIImage, shareView: ZYTrickyShareView) {
        var platformType = SSDKPlatformType.subTypeWechatSession
        switch shareType {
        case .WeiChat:
            platformType = .subTypeWechatSession
        case .WeiChatCircle:
            platformType = .subTypeWechatTimeline
        case .QQ:
            platformType = .subTypeQQFriend
        case .QZone:
            platformType = .subTypeQZone
        case .Sina:
            platformType = .typeSinaWeibo
        case .Douban:
            platformType = .typeDouBan
        case .Facebook:
            platformType = .typeFacebook
        case .Twitter:
            platformType = .typeTwitter
        case .Instagram:
            platformType = .typeInstagram
        case .GooglePlus:
            platformType = .typeGooglePlus
        }
        ZYShareClass.share.simpleShare(text: "分享内容 http://www.mob.com/", images: icon, url: URL(string: "http://wiki.mob.com")!, title: "分享标题", platformType: platformType)
    }
}
