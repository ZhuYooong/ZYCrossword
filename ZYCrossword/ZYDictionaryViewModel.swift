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
    func changeSelecttedData(with type: String) {
        
    }
    func changeUnlockedData(with type: String) {
        
    }
    //MARK: - 读取本地数据
    func loadDictionaryData(with type: String?) -> [(Row)] {
        do {
            if let typeString = type {
                return Array(try dictionaryDatabase.db.prepare(Table("WordDictionary").filter(Expression<String>("wordType") == typeString)))
            }else {
                return Array(try dictionaryDatabase.db.prepare(Table("WordDictionary")))
            }
        }catch {
            print("insertion failed: \(error)")
        }
    }
}
