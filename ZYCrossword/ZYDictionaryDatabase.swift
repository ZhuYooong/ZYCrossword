//
//  ZYDictionaryDatabase.swift
//  ZYCrossword
//
//  Created by 朱勇 on 2018/5/11.
//  Copyright © 2018年 ZhuYong. All rights reserved.
//

import Foundation
import SQLite

struct ZYDictionaryDatabase {
    var db: Connection!
    init() {
        connectDatabase()
    }
    // 与数据库建立连接
    mutating func connectDatabase() -> Void {
        do {// 与数据库建立连接
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/ZYBaseWord.sqlite3")
            db = try Connection(path)
        }catch {
            print("与数据库建立连接 失败:/(error)")
        }
    }
    
    let id = Expression<Int>("id")
    let isSelectted = Expression<Bool>("isSelectted")
    let isUnlocked = Expression<Bool>("isUnlocked")
    let isLoad = Expression<Bool>("isLoad")
    let wordType = Expression<String>("wordType")
    let number = Expression<Int>("number")
    let price = Expression<Int>("price")
    //创建表
    func tableLampCreate() -> Void {
        do {
            try db.run(Table("WordDictionary").create(ifNotExists: true, block: { (table) in
                table.column(id, primaryKey: true)
                table.column(isSelectted)
                table.column(isUnlocked)
                table.column(isLoad)
                table.column(wordType)
                table.column(number)
                table.column(price)
            }))
            UserDefaults.standard.set(5, forKey: unlockedKey)
        }catch {
            print("insertion failed: \(error)")
        }
    }
    func initFirstData() {
        do {
            let allDictionaryArray = ZYDictionaryType.allValues
            let dictionaryArray = try db.prepare(Table("WordDictionary"))
            if try db.scalar(Table("WordDictionary").count) < allDictionaryArray.count {
                for type in allDictionaryArray {
                    var isShouldUpdate = true
                    for dictionary in dictionaryArray {
                        if dictionary[Expression<String>("wordType")] == type.rawValue && dictionary[Expression<Bool>("isLoad")] == true {
                            isShouldUpdate = false
                        }
                    }
                    if isShouldUpdate {
                        tableLampInsertItem(with: type)
                    }
                }
            }
        }catch {
            print("insertion failed: \(error)")
        }
    }
    func tableLampInsertItem(with type: ZYDictionaryType) {
        var numberValue = 0
        var isSelecttedValue = false
        var isUnlockedValue = false
        var priceValue = 0
        switch type {
        case .TangPoetry300:
            numberValue = 286
            isSelecttedValue = true
            isUnlockedValue = true
            priceValue = 250
        case .SongPoetry300:
            numberValue = 289
            isSelecttedValue = false
            isUnlockedValue = true
            priceValue = 250
        case .OldPoetry300:
            numberValue = 248
            isSelecttedValue = false
            isUnlockedValue = false
            priceValue = 200
        case .ShiJing:
            numberValue = 298
            isSelecttedValue = false
            isUnlockedValue = false
            priceValue = 300
        case .YueFu:
            numberValue = 183
            isSelecttedValue = false
            isUnlockedValue = false
            priceValue = 200
        case .ChuCi:
            numberValue = 17
            isSelecttedValue = false
            isUnlockedValue = false
            priceValue = 100
        case .Top250Movie:
            numberValue = 244
            isSelecttedValue = true
            isUnlockedValue = true
            priceValue = 300
        case .Top250Book:
            numberValue = 226
            isSelecttedValue = false
            isUnlockedValue = false
            priceValue = 300
        case .Idiom:
            numberValue = 30971
            isSelecttedValue = true
            isUnlockedValue = true
            priceValue = 500
        case .Allegoric:
            numberValue = 495
            isSelecttedValue = true
            isUnlockedValue = true
            priceValue = 400
        }
        do {
            _ = try db.run(Table("WordDictionary").insert(isSelectted <- isSelecttedValue, isUnlocked <- isUnlockedValue, isLoad <- true, wordType <- type.rawValue, number <- numberValue, price <- priceValue))
        }catch {
            print("insertion failed: \(error)")
        }
    }
}
enum ZYDictionaryType: String {
    //诗歌
    case TangPoetry300 = "TangPoetry300"
    case SongPoetry300 = "SongPoetry300"
    case OldPoetry300 = "OldPoetry300"
    case ShiJing = "ShiJing"
    case YueFu = "YueFu"
    case ChuCi = "ChuCi"
    //电影
    case Top250Movie = "Top250Movie"
    //书籍
    case Top250Book = "Top250Book"
    //词典
    case Idiom = "Idiom"
    case Allegoric = "Allegoric"
    static let allValues = [TangPoetry300,SongPoetry300,OldPoetry300,ShiJing,YueFu,ChuCi,
                            Top250Movie,
                            Top250Book,
                            Idiom,Allegoric]
    static let poetryValues = [TangPoetry300.rawValue,SongPoetry300.rawValue,OldPoetry300.rawValue,ShiJing.rawValue,YueFu.rawValue,ChuCi.rawValue]
}
