//
//  ZYWordViewModel.swift
//  ZYCrossword
//
//  Created by MAC on 2017/4/28.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import Foundation
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
                return false
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
    //MARK: - 读取本地数据
    func loadWordData(with wordType: String, findString: String?, loadedWordType: ZYLoadedWordType) -> [(Row)] {
        do {
            if let str = findString {
                return try Array(documentsDatabase.db.prepare(Table(updateWordTitle(with: wordType)).filter(Expression<String>(loadedWordType.rawValue).like("%\(str)%")).order(Expression<Int>("selecttedCount")).order(Expression<Bool>("isCollect"))))
            }else {
                return try Array(documentsDatabase.db.prepare(Table(updateWordTitle(with: wordType)).order(Expression<Int>("selecttedCount")).order(Expression<Bool>("isCollect"))))
            }
        }catch {
            print("insertion failed: \(error)")
        }
        return [(Row)]()
    }
    func loadShowData() -> [(Row)] {
        var rowArray = [(Row)]()
        for dic in ZYDictionaryType.allValues {
            do {
                for row in try documentsDatabase.db.prepare(Table(dic.rawValue).filter(Expression<Bool>("isShow") == true)) {
                    rowArray.append(row)
                }
            }catch {
                print("insertion failed: \(error)")
            }
        }
        return rowArray
    }
    func loadCollectData() -> [(Row)] {
        var rowArray = [(Row)]()
        for dic in ZYDictionaryType.allValues {
            do {
                for row in try documentsDatabase.db.prepare(Table(dic.rawValue).filter(Expression<Bool>("isCollect") == true)) {
                    rowArray.append(row)
                }
            }catch {
                print("insertion failed: \(error)")
            }
        }
        return rowArray
    }
    //MARK: - Tool
    func formatConversionWord(with item: Row) -> ZYWord {
        let word = ZYWord()
        word.id = item[Expression<Int>("id")]
        word.selecttedCount = item[Expression<Int>("selecttedCount")]
        word.isCollect = item[Expression<Bool>("isCollect")]
        word.collectDate = item[Expression<Int>("collectDate")]
        word.isRight = item[Expression<Bool>("isRight")]
        word.isShow = item[Expression<Bool>("isShow")]
        
        word.showString = item[Expression<String>("showString")]
        word.wordType = item[Expression<String>("wordType")]
        
        word.name = item[Expression<String>("name")]
        word.author = item[Expression<String>("author")]
        word.detail = item[Expression<String>("detail")]
        word.url = item[Expression<String>("url")]
        word.content = item[Expression<String>("content")]
        word.date = item[Expression<String>("date")]
        word.background = item[Expression<String>("background")]
        word.database = item[Expression<String>("database")]
        word.type = item[Expression<String>("type")]
        
        word.column0 = item[Expression<String>("column0")]
        word.column1 = item[Expression<String>("column1")]
        word.column2 = item[Expression<String>("column2")]
        word.column3 = item[Expression<String>("column3")]
        word.column4 = item[Expression<String>("column4")]
        return word
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
    
    static let allValues = [ShowString,ShowString,ShowString,Author]
}
