//
//  ZYNetwordViewModel.swift
//  ZYCrossword
//
//  Created by MAC on 2017/5/10.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class ZYNetwordViewModel: NSObject {
    static let shareNetword = ZYNetwordViewModel()
    fileprivate override init() { }
    
    let realm = try! Realm()
    //MARK:图书
    func findBook(with name: String) -> ZYBook? {// 搜索图书
        var book: ZYBook?
        NetDataManager.shareNetDataManager.findBook(with: name) { (data) in
            if let data = data {
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    let rootDictionary = jsonObj.dictionaryValue
                    let fatherArray = rootDictionary["books"]!.arrayValue
                    if fatherArray.count > 1 {
                        book = ZYBook(with: fatherArray[self.randomInt(0, max: fatherArray.count - 1)])
                    }else if let bookInfo = fatherArray.first {
                        book = ZYBook(with: bookInfo)
                    }
                }
            } 
        }
        return book
    }
    //MARK:电影
    func findMovie(with name: String) -> ZYMovie? {// 搜索电影
        var movie: ZYMovie?
        NetDataManager.shareNetDataManager.findMovie(with: name) { (data) in
            if let data = data {
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    let rootDictionary = jsonObj.dictionaryValue
                    let fatherArray = rootDictionary["subjects"]!.arrayValue
                    if fatherArray.count > 1 {
                        movie = ZYMovie(with: fatherArray[self.randomInt(0, max: fatherArray.count - 1)])
                    }else if let bookInfo = fatherArray.first {
                        movie = ZYMovie(with: bookInfo)
                    }
                }
            }
        }
        return movie
    }
    func findDetailMovie(with movie: ZYMovie) -> ZYMovie {// 电影条目信息
        var detailMovie = movie
        NetDataManager.shareNetDataManager.findDetailMovie(with: movie) { (data) in
            if let data = data {
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    let rootDictionary = jsonObj.dictionaryValue
                    let fatherArray = rootDictionary["subjects"]!.arrayValue
                    if fatherArray.count > 1 {
                        detailMovie = ZYMovie(from: fatherArray[self.randomInt(0, max: fatherArray.count - 1)])
                    }else if let bookInfo = fatherArray.first {
                        detailMovie = ZYMovie(from: bookInfo)
                    }
                }
            }
        }
        return detailMovie
    }
    // MARK: - Misc
    fileprivate func randomInt(_ min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
}
