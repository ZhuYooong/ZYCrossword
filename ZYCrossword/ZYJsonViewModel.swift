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
            //诗歌
        case .TangPoetry300:
            readJson(with: "唐诗三百首", and: ZYTangPoetry300.self)
        case .SongPoetry300:
            readJson(with: "宋词三百首", and: ZYSongPoetry300.self)
        case .OldPoetry300:
            readJson(with: "古诗三百首", and: ZYOldPoetry300.self)
        case .ShiJing:
            readJson(with: "诗经", and: ZYShiJing.self)
        case .YueFu:
            readJson(with: "乐府诗集", and: ZYYueFu.self)
        case .ChuCi:
            readJson(with: "楚辞", and: ZYChuCi.self)
        case .TangPoetryAll:
            readJson(with: "", and: ZYTangPoetryAll.self)
        case .SongPoetryAll:
            readJson(with: "", and: ZYSongPoetryAll.self)
            //豆瓣
        case .Top250Movie:
            ZYNetwordViewModel.shareNetword.findTop250Movie()
        default:
            break
        }
    }
    func readJson<T: Object>(with name: String, and type: T.Type) {
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
                                    let tangPoetry300 = ZYTangPoetry300(with: des)
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
                                    let songPoetry300 = ZYSongPoetry300(with: des)
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
                                    let oldPoetry300 = ZYOldPoetry300(with: des)
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
                                    let shijing = ZYShiJing(with: des)
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
                                    let yuefu = ZYYueFu(with: des)
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
                                    let chuciItem = ZYChuCi(with: des)
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
    //MARK: - 读取本地数据
    func loadJsonData<T: Object>(with type: T.Type) -> Results<T> {
        return realm.objects(T.self).sorted(byProperty: "selecttedCount")
    }
}
