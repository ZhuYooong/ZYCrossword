//
//  ZYUserInforViewModel.swift
//  ZYCrossword
//
//  Created by 朱勇 on 2017/9/28.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import SwiftyJSON

class ZYUserInforViewModel: NSObject {
    static let shareUserInfor = ZYUserInforViewModel()
    fileprivate override init() { }
    
    //MARK: - 存储本地数据
    let realm = try! Realm()
    func initData() {
        let userInfo = ZYUserInfo()
        userInfo.coinCount = 0
        userInfo.starCount = 0
        userInfo.userIdentifier = creatUserIdentifier()
        try! realm.write {
            realm.add(userInfo, update: true)
        }
        ZYSecretClass.shareSecret.creatUserDefaults(with: userInfo.userIdentifier, defultKey: userInfoKey)
//        UserDefaults.standard.set(userInfo.userIdentifier, forKey: userInfoKey)
    }
    func changeStarCount(with level: ChangeStarLevel) {
        if let user = getUserInfo() {
            let userInfo = ZYUserInfo()
            userInfo.userIdentifier = user.userIdentifier
            if level == .third {
                userInfo.coinCount = user.coinCount + 30
            }else {
                userInfo.coinCount = user.coinCount + 10
            }
            userInfo.starCount = user.starCount + level.rawValue
            try! realm.write {
                realm.add(userInfo, update: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: coinCountKey), object: nil)
            }
        }
    }
    func changeCoin(with count: Int, add: Bool) {
        if let user = getUserInfo(), count > 0 {
            let userInfo = ZYUserInfo()
            userInfo.userIdentifier = user.userIdentifier
            if add {
                userInfo.coinCount = user.coinCount + count
            }else {
                userInfo.coinCount = user.coinCount - count
            }
            userInfo.starCount = user.starCount
            try! realm.write {
                realm.add(userInfo, update: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: coinCountKey), object: nil)
            }
        }
    }
    //MARK: - Tools
    func getUserInfo() -> ZYUserInfo? {
        if let userId = ZYSecretClass.shareSecret.getUserDefaults(with: userInfoKey) {
//        if let userId = UserDefaults.standard.string(forKey: userInfoKey) {
            let predicate = NSPredicate(format: "userIdentifier = '\(userId)'")
            if let user = self.realm.objects(ZYUserInfo.self).filter(predicate).first {
                return user
            }
        }
        return nil
    }
    func creatUserIdentifier() -> String {
        let now = Date()
        return "\(now)"
    }
}
enum ChangeStarLevel: Int {
    case first = 1
    case second = 2
    case third = 3
}
