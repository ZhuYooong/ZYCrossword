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
    func initWordData(with type: ZYWordType) {
        switch type {
        case .TangPoetry300:
            saveWordData(with: "唐诗三百首")
        case .SongPoetry300:
            saveWordData(with: "宋词三百首")
        case .OldPoetry300:
            saveWordData(with: "古诗三百首")
        case .TangPoetryAll:
            saveWordData(with: "")
        case .SongPoetryAll:
            saveWordData(with: "")
        }
    }
    func saveWordData(with name: String) {
        let predicate = NSPredicate(format: "wordType = '\(name)'")
        let word = realm.objects(ZYWord.self).filter(predicate)
        let wordInfo = ZYWord()
        wordInfo.wordType = name
        if word.count == 0 {
            wordInfo.isSelectted = "0"
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
    }
    func saveJsonData(with type: ZYWordType) {
        switch type {
        case .TangPoetry300:
            loadJson(with: "唐诗三百首", and: ZYTangPoetry300.self)
        case .SongPoetry300:
            loadJson(with: "宋词三百首", and: ZYSongPoetry300.self)
        case .OldPoetry300:
            loadJson(with: "古诗三百首", and: ZYOldPoetry300.self)
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
                        print("jsonData:\(jsonObj)")
                        if T.isKind(of: ZYTangPoetry300.self) {
                            let rootDictionary = jsonObj.dictionaryValue
                            let fatherArray = rootDictionary["father"]!.arrayValue
                            for father in fatherArray {
                                let desArray = father["des"].arrayValue
                                for des in desArray {
                                    let tangPoetry300 = ZYTangPoetry300()
                                }
                            }
                        }else if T.isKind(of: ZYSongPoetry300.self) {
                            
                        }else if T.isKind(of: ZYOldPoetry300.self) {
                            
                        }else if T.isKind(of: ZYTangPoetryAll.self) {
                            
                        }else if T.isKind(of: ZYSongPoetryAll.self) {
                            
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
    case TangPoetryAll = "全唐诗"
    case SongPoetryAll = "全宋词"
}
