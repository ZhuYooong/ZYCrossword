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
    let realm = try! Realm()
    func initData() {
        let allWordArray = ZYWordType.allValues
        for type in allWordArray {
            initWordData(with: type)
        }
    }
    func initWordData(with type: ZYWordType) {
        let wordInfo = ZYWord()
        wordInfo.wordType = type.rawValue
        switch type {
        case .Top250Movie, .NowMovie, .ShiJing, .YueFu, .ChuCi:
            wordInfo.isSelectted = "1"
        default:
            wordInfo.isSelectted = "0"
        }
        try! realm.write {
            realm.add(wordInfo, update: true)
        }
        if wordInfo.isSelectted == "1" {
            ZYJsonViewModel.shareJson.saveJsonData(with: type)
        }
    }
    func changeWordData(with type: ZYWordType) {
        let predicate = NSPredicate(format: "wordType = '\(type.rawValue)'")
        let word = self.realm.objects(ZYWord.self).filter(predicate)
        let wordInfo = ZYWord()
        wordInfo.wordType = type.rawValue
        if word.first?.isSelectted == "0" {
            wordInfo.isSelectted = "1"
        }else {
            wordInfo.isSelectted = "0"
        }
        try! self.realm.write {
            self.realm.add(wordInfo, update: true)
        }
        if wordInfo.isSelectted == "1" {
            ZYJsonViewModel.shareJson.saveJsonData(with: type)
        }
    }
    //MARK: - 读取本地数据
    func loadWordData() -> Results<ZYWord> {
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
    //豆瓣
    case FindBook = "搜索图书"
    case FindMovie = "搜索电影"
    case NowMovie = "最近的电影"
    case Top250Movie = "Top250的电影"
    case FindMusic = "搜索音乐"
    
    static let allValues = [TangPoetry300,SongPoetry300,OldPoetry300,ShiJing,YueFu,ChuCi,TangPoetryAll,SongPoetryAll,
                            FindBook,FindMovie,NowMovie,Top250Movie,FindMusic]
}
