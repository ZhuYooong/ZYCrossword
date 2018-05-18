//
//  ZYWordViewModel.swift
//  ZYCrossword
//
//  Created by MAC on 2017/4/28.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import Foundation
import SwiftyJSON
import SQLite

class ZYWordViewModel: NSObject {
    static let shareWord = ZYWordViewModel()
    fileprivate override init() { }
    
    let documentsDatabase = ZYWordDatabase(filePath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/ZYBaseWord.sqlite3"))
    fileprivate let bundleDatabase = ZYWordDatabase(filePath: Bundle.main.resourcePath!.appending("/ZYBaseWord.sqlite3"))
    //MARK: - 存储本地数据
    func saveWordData() -> Bool {
        if !FileManager.default.fileExists(atPath: documentsDatabase.path) {
            do {
                try FileManager.default.copyItem(atPath: bundleDatabase.path, toPath: documentsDatabase.path)
                return true
            }catch {
                print("insertion failed: \(error)")
            }
        }else if (FileManager.default.contentsEqual(atPath: bundleDatabase.path, andPath: documentsDatabase.path)) {
            return true
        }else {
            for dictionaryType in ZYDictionaryType.allValues {
                updateDate(with: dictionaryType.rawValue)
            }
            return true
        }
    }
    func updateDate(with wordTitle: String) {
        do {
            let documentsCount = try documentsDatabase.db.scalar(Table(wordTitle).count)
            if documentsCount > 0 {
                print("\(wordTitle) is exists")
            }else {
                creatDataWith(with: wordTitle)
            }
        }catch {
            creatDataWith(with: wordTitle)
        }
    }
    func creatDataWith(with wordTitle: String) {
        do {
            documentsDatabase.tableLampCreate(with: wordTitle)
            for item in try bundleDatabase.db.prepare(Table(wordTitle)) {
                documentsDatabase.tableLampInsertItem(with: wordTitle, item: item)
            }
            print("the end -- \(wordTitle)")
        }catch {
            print("insertion failed: \(error)")
        }
    }
    //MARK: - 更新本地数据
    func changeSelecttedData(with type: String,and id: Int) {
        
    }
    func changeCollectData(with type: String,and id: Int) {
        
    }
    func changeCollectDateData(with type: String,and id: Int) {
        
    }
    func changeRightData(with type: String,and id: Int) {
        
    }
    func changeShowData(with type: String,and id: Int) {
        
    }
    //MARK: - 读取本地数据
    func loadWordData(with wordType: String, findString: String?, loadedWordType: ZYLoadedWordType) -> [(Row)] {
        do {
            if let str = findString {
                return try Array(documentsDatabase.db.prepare(Table(updateWordTitle(with: wordType)).filter(Expression<String>(loadedWordType.rawValue).like("%\(str)%")).order(Expression<Int64>("selecttedCount")).order(Expression<Bool>("isCollect"))))
            }else {
                return try Array(documentsDatabase.db.prepare(Table(updateWordTitle(with: wordType)).order(Expression<Int64>("selecttedCount")).order(Expression<Bool>("isCollect"))))
            }
        }catch {
            print("insertion failed: \(error)")
        }
    }
    func updateWordTitle(with wordType: String) -> String {
        if wordType == "唐诗三百首" {
            return "TangPoetry300"
        }else if wordType == "宋词三百首" {
            return "SongPoetry300"
        }else if wordType == "古诗三百首" {
            return "OldPoetry300"
        }else if wordType == "诗经" {
            return "ShiJing"
        }else if wordType == "乐府诗集" {
            return "YueFu"
        }else if wordType == "楚辞" {
            return "ChuCi"
        }else if wordType == "Top250的电影" {
            return "Top250Movie"
        }else if wordType == "Top250的图书" {
            return "Top250Book"
        }else if wordType == "汉语成语词典" {
            return "Idiom"
        }else if wordType == "歇后语词典" {
            return "Allegoric"
        }else {
            return wordType
        }
    }
}
enum ZYLoadedWordType: String {
    case ShowString = "showString"
    case Author = "author"
    
    static let allValues = [ShowString,Author]
}
