//
//  ZYDictionaryViewModel.swift
//  ZYCrossword
//
//  Created by 朱勇 on 2018/5/11.
//  Copyright © 2018年 ZhuYong. All rights reserved.
//

import UIKit
import SQLite

class ZYDictionaryViewModel: NSObject {
    static let shareDictionary = ZYDictionaryViewModel()
    fileprivate override init() { }
    
    let dictionaryDatabase = ZYDictionaryDatabase()
    //MARK: - 存储本地数据
    func initDictionaryData() {
        let isSaveWordsucess = ZYWordViewModel.shareWord.saveWordData()
        if isSaveWordsucess {
            dictionaryDatabase.tableLampCreate()
            dictionaryDatabase.initFirstData()
        }
    }
    //MARK: - 更新本地数据
    func changeSelecttedData(with type: String, selectted: Bool) {
        let alice = Table("WordDictionary").filter(Expression<String>("wordType") == ZYWordViewModel.shareWord.updateWordTitle(with: type))
        do {
            try dictionaryDatabase.db.run(alice.update(Expression<Bool>("isSelectted") <- selectted))
        }catch {
            print("insertion failed: \(error)")
        }
    }
    func changeUnlockedData(with type: String) {
        let alice = Table("WordDictionary").filter(Expression<String>("wordType") == ZYWordViewModel.shareWord.updateWordTitle(with: type))
        do {
            try dictionaryDatabase.db.run(alice.update(Expression<Bool>("isUnlocked") <- true))
        }catch {
            print("insertion failed: \(error)")
        }
    }
    //MARK: - 读取本地数据
    func loadDictionaryData(with type: String?) -> [(Row)] {
        do {
            if let typeString = type {
                return Array(try dictionaryDatabase.db.prepare(Table("WordDictionary").filter(Expression<String>("wordType") == ZYWordViewModel.shareWord.updateWordTitle(with: typeString))))
            }else {
                return Array(try dictionaryDatabase.db.prepare(Table("WordDictionary")))
            }
        }catch {
            print("insertion failed: \(error)")
        }
        return [(Row)]()
    }
    //MARK: - Tool
    func formatConversionDictionary(with item: Row) -> ZYDictionary {
        let dictionary = ZYDictionary()
        dictionary.id = item[Expression<Int>("id")]
        dictionary.isSelectted = item[Expression<Bool>("isSelectted")]
        dictionary.isUnlocked = item[Expression<Bool>("isUnlocked")]
        dictionary.isLoad = item[Expression<Bool>("isLoad")]
        dictionary.wordType = item[Expression<String>("wordType")]
        dictionary.number = item[Expression<Int>("number")]
        dictionary.price = item[Expression<Int>("price")]
        return dictionary
    }
}
