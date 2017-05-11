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
                        movie = ZYMovie(base: fatherArray[self.randomInt(0, max: fatherArray.count - 1)])
                    }else if let movieInfo = fatherArray.first {
                        movie = ZYMovie(base: movieInfo)
                    }
                }
            }
        }
        return movie
    }
    func findNowMovie() -> List<ZYMovie> {// 最近的电影
        let concurrentQueue = DispatchQueue(label: "findNowMovie", attributes: .concurrent)
        let group = DispatchGroup()
        let movieResults = List<ZYMovie>()
        group.enter()
        concurrentQueue.async {// 正在上映的电影
            NetDataManager.shareNetDataManager.findTheatersMovie { (data) in
                if let data = data {
                    let jsonObj = JSON(data: data)
                    if jsonObj != JSON.null {
                        let rootDictionary = jsonObj.dictionaryValue
                        let fatherArray = rootDictionary["subjects"]!.arrayValue
                        for movieInfo in fatherArray {
                            movieResults.append(self.findDetailMovie(with: ZYMovie(save: movieInfo, and: ZYMovieType.Theaters.rawValue)))
                        }
                    }
                }
            }
            group.leave()
        }
        group.enter()
        concurrentQueue.async {// 即将上映的电影
            NetDataManager.shareNetDataManager.findComingMovie { (data) in
                if let data = data {
                    let jsonObj = JSON(data: data)
                    if jsonObj != JSON.null {
                        let rootDictionary = jsonObj.dictionaryValue
                        let fatherArray = rootDictionary["subjects"]!.arrayValue
                        for movieInfo in fatherArray {
                            movieResults.append(self.findDetailMovie(with: ZYMovie(save: movieInfo, and: ZYMovieType.Coming.rawValue)))
                        }
                    }
                }
            }
            group.leave()
        }
        group.enter()
        concurrentQueue.async {// 新片榜的电影
            NetDataManager.shareNetDataManager.findNewMovie { (data) in
                if let data = data {
                    let jsonObj = JSON(data: data)
                    if jsonObj != JSON.null {
                        let rootDictionary = jsonObj.dictionaryValue
                        let fatherArray = rootDictionary["subjects"]!.arrayValue
                        for movieInfo in fatherArray {
                            movieResults.append(self.findDetailMovie(with: ZYMovie(save: movieInfo, and: ZYMovieType.New.rawValue)))
                        }
                    }
                }
            }
            group.leave()
        }
        group.enter()
        concurrentQueue.async {// 北美票房榜的电影
            NetDataManager.shareNetDataManager.findBoxMovie { (data) in
                if let data = data {
                    let jsonObj = JSON(data: data)
                    if jsonObj != JSON.null {
                        let rootDictionary = jsonObj.dictionaryValue
                        let fatherArray = rootDictionary["subjects"]!.arrayValue
                        for movieInfo in fatherArray {
                            movieResults.append(self.findDetailMovie(with: ZYMovie(save: movieInfo, and: ZYMovieType.Box.rawValue)))
                        }
                    }
                }
            }
            group.leave()
        }
        _ = group.wait(timeout: .distantFuture)
        return movieResults
    }
    func findTop250Movie() {// Top250的电影
        if realm.objects(ZYMovie.self).filter(NSPredicate(format: "type = '\(ZYMovieType.Top250.rawValue)'")).count == 0 {
            NetDataManager.shareNetDataManager.findTop250Movie { (data) in
                if let data = data {
                    let jsonObj = JSON(data: data)
                    if jsonObj != JSON.null {
                        let rootDictionary = jsonObj.dictionaryValue
                        let fatherArray = rootDictionary["subjects"]!.arrayValue
                        for movieInfo in fatherArray {
                            let topMovie = self.findDetailMovie(with: ZYMovie(save: movieInfo, and: ZYMovieType.Top250.rawValue))
                            try! self.realm.write {
                                self.realm.add(topMovie, update: true)
                            }
                        }
                    }
                }
            }
        }
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
                        detailMovie = ZYMovie(detail: fatherArray[self.randomInt(0, max: fatherArray.count - 1)])
                    }else if let bookInfo = fatherArray.first {
                        detailMovie = ZYMovie(detail: bookInfo)
                    }
                }
            }
        }
        return detailMovie
    }
    //MARK:音乐
    func findMusic(with name: String) -> ZYMusic? {// 搜索音乐
        var book: ZYMusic?
        NetDataManager.shareNetDataManager.findMusic(with: name) { (data) in
            if let data = data {
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    let rootDictionary = jsonObj.dictionaryValue
                    let fatherArray = rootDictionary["musics"]!.arrayValue
                    if fatherArray.count > 1 {
                        book = ZYMusic(with: fatherArray[self.randomInt(0, max: fatherArray.count - 1)])
                    }else if let bookInfo = fatherArray.first {
                        book = ZYMusic(with: bookInfo)
                    }
                }
            }
        }
        return book
    }
    // MARK: - Misc
    fileprivate func randomInt(_ min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
}
