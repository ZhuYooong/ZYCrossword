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
    func initWordData() {
        let allWordArray = ZYWordType.allValues
        for type in allWordArray {
            saveWordData(with: type)
        }
    }
    func saveWordData(with type: ZYWordType) {
        let predicate = NSPredicate(format: "wordType = '\(type.rawValue)'")
        let word = realm.objects(ZYWord.self).filter(predicate)
        let wordInfo = ZYWord()
        wordInfo.wordType = type.rawValue
        if word.count == 0 {
            switch type {
            case .TangPoetry300, .SongPoetry300, .OldPoetry300:
                wordInfo.isSelectted = "1"
            default:
                wordInfo.isSelectted = "0"
            }
        }else {
            if word.first?.isSelectted == "0" {
                wordInfo.isSelectted = "1"
            }else {
                wordInfo.isSelectted = "0"
            }
        }
        try! realm.write {
            realm.add(wordInfo, update: true)
        }
        if wordInfo.isSelectted == "1" {
            saveJsonData(with: type)
        }
    }
    func saveJsonData(with type: ZYWordType) {
        switch type {
        case .TangPoetry300:
            loadJson(with: "唐诗三百首", and: ZYTangPoetry300.self)
        case .SongPoetry300:
            loadJson(with: "宋词三百首", and: ZYSongPoetry300.self)
        case .OldPoetry300:
            loadJson(with: "古诗三百首", and: ZYOldPoetry300.self)
        case .ShiJing:
            loadJson(with: "诗经", and: ZYShiJing.self)
        case .YueFu:
            loadJson(with: "乐府诗集", and: ZYYueFu.self)
        case .ChuCi:
            loadJson(with: "楚辞", and: ZYChuCi.self)
        case .TangPoetryAll:
            loadJson(with: "", and: ZYTangPoetryAll.self)
        case .SongPoetryAll:
            loadJson(with: "", and: ZYSongPoetryAll.self)
        }
    }
    func loadJson<T: Object>(with name: String, and type: T.Type) {
        if realm.objects(T.self).count == 0 {
            if let path = Bundle.main.path(forResource: name, ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                    let jsonObj = JSON(data: data)
                    if jsonObj != JSON.null {
                        if T.self == ZYTangPoetry300.self {
                            let rootDictionary = jsonObj.dictionaryValue
                            let fatherArray = rootDictionary["father"]!.arrayValue
                            for father in fatherArray {
                                let desArray = father["des"].arrayValue
                                for des in desArray {
                                    let tangPoetry300 = ZYTangPoetry300()
                                    tangPoetry300.author = des["detail_author"].arrayValue.first?.stringValue
                                    tangPoetry300.background = des["detail_background_text"].arrayValue.first?.stringValue
                                    tangPoetry300.title = des["title"].stringValue
                                    tangPoetry300.detail = des["detail_text"].stringValue
                                    tangPoetry300.url = des["url"].stringValue
                                    tangPoetry300.appreciation = des["detail_appreciation_text"].arrayValue.first?.stringValue
                                    let translateAndNoteArray = des["detail_translate_text"].arrayValue
                                    var translateString = ""
                                    var noteString = ""
                                    var isTranslateOrNote = 0
                                    for translateOrNote in translateAndNoteArray {
                                        if isTranslateOrNote == 2 {//注释
                                            if translateOrNote.stringValue[translateOrNote.stringValue.startIndex] == "(" {
                                                noteString += "\n\(translateOrNote.stringValue)"
                                            }else {
                                                noteString += translateOrNote.stringValue
                                            }
                                        }
                                        if translateOrNote.stringValue == "注释" {
                                            isTranslateOrNote = 2
                                        }
                                        if isTranslateOrNote == 1 {//译文
                                            translateString += translateOrNote.stringValue
                                        }
                                        if translateOrNote.stringValue == "译文" {
                                            isTranslateOrNote = 1
                                        }
                                    }
                                    tangPoetry300.note = translateString
                                    tangPoetry300.translate = noteString
                                    try! realm.write {
                                        realm.add(tangPoetry300, update: true)
                                    }
                                }
                            }
                        }else if T.self == ZYSongPoetry300.self {
                            let rootDictionary = jsonObj.dictionaryValue
                            let chuciArray = rootDictionary["chuci"]!.arrayValue
                            for chuci in chuciArray {
                                let desArray = chuci["des"].arrayValue
                                for des in desArray {
                                    let songPoetry300 = ZYSongPoetry300()
                                    songPoetry300.author = des["detail_author"].arrayValue.first?.stringValue
                                    songPoetry300.background = des["detail_background_text"].arrayValue.first?.stringValue
                                    songPoetry300.title = des["title"].stringValue
                                    songPoetry300.detail = des["detail_text"].stringValue
                                    songPoetry300.url = des["url"].stringValue
                                    songPoetry300.appreciation = des["detail_appreciation_text"].arrayValue.first?.stringValue
                                    let translateAndNoteArray = des["detail_translate_text"].arrayValue
                                    var translateString = ""
                                    var noteString = ""
                                    var isTranslateOrNote = 0
                                    for translateOrNote in translateAndNoteArray {
                                        if isTranslateOrNote == 2 {//注释
                                            if translateOrNote.stringValue[translateOrNote.stringValue.startIndex] == "(" {
                                                noteString += "\n\(translateOrNote.stringValue)"
                                            }else {
                                                noteString += translateOrNote.stringValue
                                            }
                                        }
                                        if translateOrNote.stringValue == "注释" {
                                            isTranslateOrNote = 2
                                        }
                                        if isTranslateOrNote == 1 {//译文
                                            translateString += translateOrNote.stringValue
                                        }
                                        if translateOrNote.stringValue == "译文" {
                                            isTranslateOrNote = 1
                                        }
                                    }
                                    songPoetry300.note = translateString
                                    songPoetry300.translate = noteString
                                    try! realm.write {
                                        realm.add(songPoetry300, update: true)
                                    }
                                }
                            }
                        }else if T.self == ZYOldPoetry300.self {
                            let rootDictionary = jsonObj.dictionaryValue
                            let chuciArray = rootDictionary["chuci"]!.arrayValue
                            for chuci in chuciArray {
                                let desArray = chuci["des"].arrayValue
                                for des in desArray {
                                    let oldPoetry300 = ZYOldPoetry300()
                                    oldPoetry300.author = des["detail_author"].arrayValue.first?.stringValue
                                    oldPoetry300.background = des["detail_background_text"].arrayValue.first?.stringValue
                                    oldPoetry300.title = des["title"].stringValue
                                    oldPoetry300.detail = des["detail_text"].stringValue
                                    oldPoetry300.url = des["url"].stringValue
                                    oldPoetry300.appreciation = des["detail_appreciation_text"].arrayValue.first?.stringValue
                                    let translateAndNoteArray = des["detail_translate_text"].arrayValue
                                    var translateString = ""
                                    var noteString = ""
                                    var isTranslateOrNote = 0
                                    for translateOrNote in translateAndNoteArray {
                                        if isTranslateOrNote == 2 {//注释
                                            if translateOrNote.stringValue[translateOrNote.stringValue.startIndex] == "(" {
                                                noteString += "\n\(translateOrNote.stringValue)"
                                            }else {
                                                noteString += translateOrNote.stringValue
                                            }
                                        }
                                        if translateOrNote.stringValue == "注释" {
                                            isTranslateOrNote = 2
                                        }
                                        if isTranslateOrNote == 1 {//译文
                                            translateString += translateOrNote.stringValue
                                        }
                                        if translateOrNote.stringValue == "译文" {
                                            isTranslateOrNote = 1
                                        }
                                    }
                                    oldPoetry300.note = translateString
                                    oldPoetry300.translate = noteString
                                    try! realm.write {
                                        realm.add(oldPoetry300, update: true)
                                    }
                                }
                            }
                        }else if T.self == ZYShiJing.self {
                            let rootDictionary = jsonObj.dictionaryValue
                            let chuciArray = rootDictionary["chuci"]!.arrayValue
                            for chuci in chuciArray {
                                let desArray = chuci["des"].arrayValue
                                for des in desArray {
                                    let shijing = ZYShiJing()
                                    shijing.author = des["detail_author"].arrayValue.first?.stringValue
                                    shijing.background = des["detail_background_text"].arrayValue.first?.stringValue
                                    shijing.title = des["title"].stringValue
                                    shijing.detail = des["detail_text"].stringValue
                                    shijing.url = des["url"].stringValue
                                    shijing.appreciation = des["detail_appreciation_text"].arrayValue.first?.stringValue
                                    let translateAndNoteArray = des["detail_translate_text"].arrayValue
                                    var translateString = ""
                                    var noteString = ""
                                    var isTranslateOrNote = 0
                                    for translateOrNote in translateAndNoteArray {
                                        if isTranslateOrNote == 2 {//注释
                                            if translateOrNote.stringValue[translateOrNote.stringValue.startIndex] == "(" {
                                                noteString += "\n\(translateOrNote.stringValue)"
                                            }else {
                                                noteString += translateOrNote.stringValue
                                            }
                                        }
                                        if translateOrNote.stringValue == "注释" {
                                            isTranslateOrNote = 2
                                        }
                                        if isTranslateOrNote == 1 {//译文
                                            translateString += translateOrNote.stringValue
                                        }
                                        if translateOrNote.stringValue == "译文" {
                                            isTranslateOrNote = 1
                                        }
                                    }
                                    shijing.note = translateString
                                    shijing.translate = noteString
                                    try! realm.write {
                                        realm.add(shijing, update: true)
                                    }
                                }
                            }
                        }else if T.self == ZYYueFu.self {
                            let rootDictionary = jsonObj.dictionaryValue
                            let chuciArray = rootDictionary["chuci"]!.arrayValue
                            for chuci in chuciArray {
                                let desArray = chuci["des"].arrayValue
                                for des in desArray {
                                    let yuefu = ZYYueFu()
                                    yuefu.author = des["detail_author"].arrayValue.first?.stringValue
                                    yuefu.background = des["detail_background_text"].arrayValue.first?.stringValue
                                    yuefu.title = des["title"].stringValue
                                    yuefu.detail = des["detail_text"].stringValue
                                    yuefu.url = des["url"].stringValue
                                    yuefu.appreciation = des["detail_appreciation_text"].arrayValue.first?.stringValue
                                    let translateAndNoteArray = des["detail_translate_text"].arrayValue
                                    var translateString = ""
                                    var noteString = ""
                                    var isTranslateOrNote = 0
                                    for translateOrNote in translateAndNoteArray {
                                        if isTranslateOrNote == 2 {//注释
                                            if translateOrNote.stringValue[translateOrNote.stringValue.startIndex] == "(" {
                                                noteString += "\n\(translateOrNote.stringValue)"
                                            }else {
                                                noteString += translateOrNote.stringValue
                                            }
                                        }
                                        if translateOrNote.stringValue == "注释" {
                                            isTranslateOrNote = 2
                                        }
                                        if isTranslateOrNote == 1 {//译文
                                            translateString += translateOrNote.stringValue
                                        }
                                        if translateOrNote.stringValue == "译文" {
                                            isTranslateOrNote = 1
                                        }
                                    }
                                    yuefu.note = translateString
                                    yuefu.translate = noteString
                                    try! realm.write {
                                        realm.add(yuefu, update: true)
                                    }
                                }
                            }
                        }else if T.self == ZYChuCi.self {
                            let rootDictionary = jsonObj.dictionaryValue
                            let chuciArray = rootDictionary["chuci"]!.arrayValue
                            for chuci in chuciArray {
                                let desArray = chuci["des"].arrayValue
                                for des in desArray {
                                    let chuciItem = ZYChuCi()
                                    chuciItem.author = des["detail_author"].arrayValue.first?.stringValue
                                    chuciItem.background = des["detail_background_text"].arrayValue.first?.stringValue
                                    chuciItem.title = des["title"].stringValue
                                    chuciItem.detail = des["detail_text"].stringValue
                                    chuciItem.url = des["url"].stringValue
                                    chuciItem.appreciation = des["detail_appreciation_text"].arrayValue.first?.stringValue
                                    let translateAndNoteArray = des["detail_translate_text"].arrayValue
                                    var translateString = ""
                                    var noteString = ""
                                    var isTranslateOrNote = 0
                                    for translateOrNote in translateAndNoteArray {
                                        if isTranslateOrNote == 2 {//注释
                                            if translateOrNote.stringValue[translateOrNote.stringValue.startIndex] == "(" {
                                                noteString += "\n\(translateOrNote.stringValue)"
                                            }else {
                                                noteString += translateOrNote.stringValue
                                            }
                                        }
                                        if translateOrNote.stringValue == "注释" {
                                            isTranslateOrNote = 2
                                        }
                                        if isTranslateOrNote == 1 {//译文
                                            translateString += translateOrNote.stringValue
                                        }
                                        if translateOrNote.stringValue == "译文" {
                                            isTranslateOrNote = 1
                                        }
                                    }
                                    chuciItem.note = translateString
                                    chuciItem.translate = noteString
                                    try! realm.write {
                                        realm.add(chuciItem, update: true)
                                    }
                                }
                            }
                        }else if T.self == ZYTangPoetryAll.self {
                            
                        }else if T.self == ZYSongPoetryAll.self {
                            
                        }
                    }else {
                        print("Could not get json from file, make sure that file contains valid json.")
                    }
                }catch let error {
                    print(error.localizedDescription)
                }
            }else {
                print("Invalid filename/path.")
            }
        }
    }
}
enum ZYWordType: String {
    case TangPoetry300 = "唐诗三百首"
    case SongPoetry300 = "宋词三百首"
    case OldPoetry300 = "古诗三百首"
    case ShiJing = "诗经"
    case YueFu = "乐府诗集"
    case ChuCi = "楚辞"
    case TangPoetryAll = "全唐诗"
    case SongPoetryAll = "全宋词"
    
    static let allValues = [TangPoetry300,SongPoetry300,OldPoetry300,ShiJing,YueFu,ChuCi,TangPoetryAll,SongPoetryAll]
}
