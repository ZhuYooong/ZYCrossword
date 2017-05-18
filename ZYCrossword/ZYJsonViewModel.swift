//
//  ZYJsonViewModel.swift
//  ZYCrossword
//
//  Created by MAC on 2017/5/4.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class ZYJsonViewModel: NSObject {
    static let shareJson = ZYJsonViewModel()
    fileprivate override init() { }
    
    //MARK: - 存储本地数据
    let realm = try! Realm()
    func saveJsonData(with type: ZYWordType) {
        switch type {
        case .TangPoetry300, .SongPoetry300, .OldPoetry300, .ShiJing, .YueFu, .ChuCi, .TangPoetryAll, .SongPoetryAll: //诗歌
            readJson(with: type.rawValue, and: ZYPoetry.self)
        case .Top250Movie: //电影
            readJson(with: type.rawValue, and: ZYMovie.self)
        case .Top250Book: //书籍
            readJson(with: type.rawValue, and: ZYBook.self)
        case .Idiom: //词典
            readJson(with: type.rawValue, and: ZYIdiom.self)
        }
    }
    func readJson<T: Object>(with name: String, and type: T.Type) {
        if realm.objects(T.self).count == 0 {
            if let path = Bundle.main.path(forResource: name, ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                    let jsonObj = JSON(data: data)
                    if jsonObj != JSON.null {
                        if T.self == ZYPoetry.self { //诗歌
                            let rootDictionary = jsonObj.dictionaryValue
                            let fatherArray = rootDictionary["father"]!.arrayValue
                            for father in fatherArray {
                                let desArray = father["des"].arrayValue
                                for des in desArray {
                                    let tangPoetry300 = ZYPoetry(with: des, and: name)
                                    try! realm.write {
                                        realm.add(tangPoetry300, update: true)
                                    }
                                }
                            }
                        }else if T.self == ZYMovie.self { //电影
                            let rootDictionary = jsonObj.dictionaryValue
                            let chuciArray = rootDictionary["father"]!.arrayValue
                            for chuci in chuciArray {
                                let chuciItem = ZYMovie(with: chuci, and: name)
                                try! realm.write {
                                    realm.add(chuciItem, update: true)
                                }
                            }
                        }else if T.self == ZYBook.self {//书籍
                            let chuciArray = jsonObj.arrayValue
                            for chuci in chuciArray {
                                let chuciItem = ZYBook(with: chuci, and: name)
                                try! realm.write {
                                    realm.add(chuciItem, update: true)
                                }
                            }
                        }else if T.self == ZYIdiom.self { //词典
                            let rootDictionary = jsonObj.dictionaryValue
                            let chuciArray = rootDictionary["father"]!.arrayValue
                            for chuci in chuciArray {
                                let chuciItem = ZYMovie(with: chuci, and: name)
                                try! realm.write {
                                    realm.add(chuciItem, update: true)
                                }
                            }
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
    //MARK: - 读取本地数据
    func loadJsonData<T: Object>(with type: T.Type, and wordType: String?) -> Results<T> {
        if let str = wordType {
            return realm.objects(T.self).filter(NSPredicate(format: "wordType = '\(str)'")).sorted(byProperty: "selecttedCount")
        }else {
            return realm.objects(T.self).sorted(byProperty: "selecttedCount")
        }
    }
}
