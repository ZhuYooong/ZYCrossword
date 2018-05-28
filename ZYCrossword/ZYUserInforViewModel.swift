//
//  ZYUserInforViewModel.swift
//  ZYCrossword
//
//  Created by 朱勇 on 2017/9/28.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import SQLite

class ZYUserInforViewModel: NSObject {
    static let shareUserInfor = ZYUserInforViewModel()
    fileprivate override init() { }
    
    //MARK: - 存储本地数据
    let userInforDatabase = ZYUserInforDatabase()
    func initUserInfor() {
        userInforDatabase.tableLampCreate()
        userInforDatabase.initFirstData()
    }
    //MARK: - 更新本地数据
    func changeStarCount(with level: ChangeStarLevel) {
        if let user = getUserInfo() {
            userInforDatabase.tableLampUpdateRow(with: .starCount, count: level.rawValue, word: user)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: coinCountKey), object: nil)
        }
    }
    func changeCoin(with count: Int, add: Bool) {
        if let user = getUserInfo(), count > 0 {
            if add {
                userInforDatabase.tableLampUpdateRow(with: .addCoin, count: count, word: user)
            }else {
                userInforDatabase.tableLampUpdateRow(with: .subtractCoin, count: count, word: user)
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: coinCountKey), object: nil)
        }
    }
    //MARK: - 读取本地数据
    func getUserInfo() -> Row? {
        do {
            if let userId = ZYSecretClass.shareSecret.getUserDefaults(with: userInfoKey) {
                return Array(try userInforDatabase.db.prepare(Table("UserInfor").filter(Expression<String>("userIdentifier") == userId))).first
            }
        }catch {
            print("insertion failed: \(error)")
        }
        return nil
    }
    //MARK: - Tools
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
