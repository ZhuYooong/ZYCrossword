//
//  ZYUserInforDatabase.swift
//  ZYCrossword
//
//  Created by 朱勇 on 2018/5/21.
//  Copyright © 2018年 ZhuYong. All rights reserved.
//

import UIKit
import SQLite

class ZYUserInforDatabase: NSObject {
    var db: Connection!
    override init() {
        super.init()
        connectDatabase()
    }
    // 与数据库建立连接
    func connectDatabase() -> Void {
        do {// 与数据库建立连接
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/ZYBaseWord.sqlite3")
            db = try Connection(path)
        }catch {
            print("与数据库建立连接 失败:/(error)")
        }
    }
    
    let id = Expression<Int>("id")
    let userIdentifier = Expression<String>("userIdentifier")
    let starCount = Expression<Int>("starCount")
    let coinCount = Expression<Int>("coinCount")
    //创建表
    func tableLampCreate() -> Void {
        do {
            try db.run(Table("UserInfor").create(ifNotExists: true, block: { (table) in
                table.column(id, primaryKey: true)
                table.column(userIdentifier)
                table.column(starCount)
                table.column(coinCount)
            }))
        }catch {
            print("insertion failed: \(error)")
        }
    }
    func initFirstData() {
        let identifier = ZYUserInforViewModel.shareUserInfor.creatUserIdentifier()
        do {
            try db.run(Table("UserInfor").insert(userIdentifier <- identifier, starCount <- 0, coinCount <- 0))
        }catch {
            print("insertion failed: \(error)")
        }
        ZYSecretClass.shareSecret.creatUserDefaults(with: identifier, defultKey: userInfoKey)
    }
    //替换
    func tableLampUpdateRow(with type: ZYUserInforUpdateType, count: Int, word: Row) {
        let alice = Table("UserInfor").filter(id == word[Expression<Int>("id")])
        do {
            switch type {
            case .starCount:
                var coin = word[Expression<Int>("coinCount")] + 10
                if count == 3 {
                    coin += 20
                }
                try db.run(alice.update(coinCount <- coin, starCount <- (word[Expression<Int>("starCount")] + count)))
            case .addCoin:
                try db.run(alice.update(coinCount <- (word[Expression<Int>("coinCount")] + count)))
            case .subtractCoin:
                try db.run(alice.update(coinCount <- (word[Expression<Int>("coinCount")] - count)))
            }
        }catch {
            print("insertion failed: \(error)")
        }
    }
}
enum ZYUserInforUpdateType: Int {
    case starCount = 0
    case addCoin = 1
    case subtractCoin = 2
}
