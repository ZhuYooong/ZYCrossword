//
//  ZYDictionaryViewModel.swift
//  ZYCrossword
//
//  Created by 朱勇 on 2018/5/11.
//  Copyright © 2018年 ZhuYong. All rights reserved.
//

import UIKit

class ZYDictionaryViewModel: NSObject {
    static let shareDictionary = ZYDictionaryViewModel()
    fileprivate override init() { }
    
    //MARK: - 存储本地数据
    func initFirstData() {
        let realm = try! Realm()
        let allWordArray = ZYWordType.allValues
        let wordArray = realm.objects(ZYWord.self)
        for type in allWordArray {
            var isShouldUpdate = true
            for word in wordArray {
                if word.wordType == type.rawValue && word.isLoad == true {
                    isShouldUpdate = false
                }
            }
            if isShouldUpdate {
                initWordData(with: type, and: realm)
            }
        }
        UserDefaults.standard.set(5, forKey: unlockedKey)
    }
    func initWordData(with type: ZYWordType, and realm: Realm) {
        let wordInfo = ZYWord()
        wordInfo.wordType = type.rawValue
        wordInfo.isLoad = false
        switch type {
        case .TangPoetry300:
            wordInfo.number = 286
            wordInfo.isSelectted = true
            wordInfo.isUnlocked = true
            wordInfo.price = 250
        case .SongPoetry300:
            wordInfo.number = 289
            wordInfo.isSelectted = false
            wordInfo.isUnlocked = true
            wordInfo.price = 250
        case .OldPoetry300:
            wordInfo.number = 248
            wordInfo.isSelectted = false
            wordInfo.isUnlocked = false
            wordInfo.price = 200
        case .ShiJing:
            wordInfo.number = 298
            wordInfo.isSelectted = false
            wordInfo.isUnlocked = false
            wordInfo.price = 300
        case .YueFu:
            wordInfo.number = 183
            wordInfo.isSelectted = false
            wordInfo.isUnlocked = false
            wordInfo.price = 200
        case .ChuCi:
            wordInfo.number = 17
            wordInfo.isSelectted = false
            wordInfo.isUnlocked = false
            wordInfo.price = 100
        case .TangPoetryAll:
            wordInfo.number = 0
            wordInfo.isSelectted = false
            wordInfo.isUnlocked = false
            wordInfo.price = 100
        case .SongPoetryAll:
            wordInfo.number = 0
            wordInfo.isSelectted = false
            wordInfo.isUnlocked = false
            wordInfo.price = 100
        case .Top250Movie:
            wordInfo.number = 244
            wordInfo.isSelectted = true
            wordInfo.isUnlocked = true
            wordInfo.price = 300
        case .Top250Book:
            wordInfo.number = 226
            wordInfo.isSelectted = false
            wordInfo.isUnlocked = false
            wordInfo.price = 300
        case .Idiom:
            wordInfo.number = 30971
            wordInfo.isSelectted = true
            wordInfo.isUnlocked = true
            wordInfo.price = 500
        case .Allegoric:
            wordInfo.number = 495
            wordInfo.isSelectted = true
            wordInfo.isUnlocked = true
            wordInfo.price = 400
        }
        try! realm.write {
            realm.add(wordInfo, update: true)
        }
        if wordInfo.isUnlocked == true && wordInfo.isLoad == false {
            ZYJsonViewModel.shareJson.saveJsonData(with: type, and: realm)
        }
    }
    func initOtherData() {
        let realm = try! Realm()
        let allWordArray = ZYWordViewModel.shareWord.loadWordData(with: realm)
        for word in allWordArray {
            if word.isUnlocked == false && word.isLoad == false {
                for wordType in ZYWordType.allValues {
                    if wordType.rawValue == word.wordType {
                        ZYJsonViewModel.shareJson.saveJsonData(with: wordType, and: realm)
                    }
                }
            }
        }
    }
    //MARK: 修改本地数据
    func clickWordData(with type: String, and realm: Realm) {
        let word = realm.objects(ZYWord.self).filter(NSPredicate(format: "wordType = '\(type)'"))
        let wordInfo = ZYWord()
        wordInfo.wordType = type
        wordInfo.number = word.first?.number ?? 0
        wordInfo.price = word.first?.price ?? 0
        wordInfo.isUnlocked = word.first?.isUnlocked ?? false
        wordInfo.isLoad = word.first?.isLoad ?? false
        if word.first?.isSelectted == false {
            wordInfo.isSelectted = true
        }else {
            wordInfo.isSelectted = false
        }
        try! realm.write {
            realm.add(wordInfo, update: true)
        }
    }
    func unlockWordData(with word: ZYWord, and realm: Realm) {
        let wordInfo = ZYWord()
        wordInfo.wordType = word.wordType
        wordInfo.number = word.number
        wordInfo.price = word.price
        wordInfo.isSelectted = word.isSelectted
        wordInfo.isLoad = word.isLoad
        wordInfo.isUnlocked = true
        try! realm.write {
            realm.add(wordInfo, update: true)
        }
    }
    func alreadyLoadWordData(with word: ZYWord, and realm: Realm) {
        let wordInfo = ZYWord()
        wordInfo.wordType = word.wordType
        wordInfo.number = word.number
        wordInfo.price = word.price
        wordInfo.isUnlocked = word.isUnlocked
        wordInfo.isLoad = true
        wordInfo.isSelectted = word.isSelectted
        try! realm.write {
            realm.add(wordInfo, update: true)
        }
    }
    //MARK: - 读取本地数据
    func loadWordData(with realm: Realm) -> Results<ZYWord> {
        return realm.objects(ZYWord.self)
    }
}
