//
//  ZYWordViewModel.swift
//  ZYCrossword
//
//  Created by MAC on 2017/4/28.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class ZYWordViewModel: NSObject {
    static let shareWord = ZYWordViewModel()
    fileprivate override init() { }
    
    //MARK: - 存储本地数据
    func initData() {
        let realm = try! Realm()
        let allWordArray = ZYWordType.allValues
        if realm.objects(ZYWord.self).count < allWordArray.count {
            for type in allWordArray {
                initWordData(with: type, and: realm)
            }
        }
    }
    func initWordData(with type: ZYWordType, and realm: Realm) {
        let wordInfo = ZYWord()
        wordInfo.wordType = type.rawValue
        switch type {
        case .TangPoetry300:
            wordInfo.number = 286
            wordInfo.isSelectted = true
        case .SongPoetry300:
            wordInfo.number = 289
            wordInfo.isSelectted = true
        case .OldPoetry300:
            wordInfo.number = 248
            wordInfo.isSelectted = false
        case .ShiJing:
            wordInfo.number = 298
            wordInfo.isSelectted = false
        case .YueFu:
            wordInfo.number = 183
            wordInfo.isSelectted = false
        case .ChuCi:
            wordInfo.number = 17
            wordInfo.isSelectted = false
        case .TangPoetryAll:
            wordInfo.number = 0
            wordInfo.isSelectted = false
        case .SongPoetryAll:
            wordInfo.number = 0
            wordInfo.isSelectted = false
        case .Top250Movie:
            wordInfo.number = 244
            wordInfo.isSelectted = true
        case .Top250Book:
            wordInfo.number = 226
            wordInfo.isSelectted = false
        case .Idiom:
            wordInfo.number = 30971
            wordInfo.isSelectted = true
        case .Allegoric:
            wordInfo.number = 495
            wordInfo.isSelectted = true
        default:
            wordInfo.isSelectted = false
        }
        try! realm.write {
            realm.add(wordInfo, update: true)
        }
        ZYJsonViewModel.shareJson.saveJsonData(with: type, and: realm)
    }
    func changeWordData(with type: String, and realm: Realm) {
        let predicate = NSPredicate(format: "wordType = '\(type)'")
        let word = realm.objects(ZYWord.self).filter(predicate)
        let wordInfo = ZYWord()
        wordInfo.wordType = type
        if word.first?.isSelectted == false {
            wordInfo.isSelectted = true
        }else {
            wordInfo.isSelectted = false
        }
        try! realm.write {
            realm.add(wordInfo, update: true)
        }
    }
    //MARK: - 读取本地数据
    func loadWordData(with realm: Realm) -> Results<ZYWord> {
        return realm.objects(ZYWord.self)
    }
}
enum ZYWordType: String {
    //诗歌
    case TangPoetry300 = "唐诗三百首"
    case SongPoetry300 = "宋词三百首"
    case OldPoetry300 = "古诗三百首"
    case ShiJing = "诗经"
    case YueFu = "乐府诗集"
    case ChuCi = "楚辞"
    case TangPoetryAll = "全唐诗"
    case SongPoetryAll = "全宋词"
    //电影
    case Top250Movie = "Top250的电影"
    //书籍
    case Top250Book = "Top250的图书"
    //词典
    case Idiom = "汉语成语词典"
    case Allegoric = "歇后语词典"
    static let allValues = [TangPoetry300,SongPoetry300,OldPoetry300,ShiJing,YueFu,ChuCi,TangPoetryAll,SongPoetryAll,
                            Top250Movie,
                            Top250Book,
                            Idiom,Allegoric]
}
