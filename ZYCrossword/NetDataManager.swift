//
//  NetDataManager.swift
//  ZYFastApp
//
//  Created by MAC on 16/8/15.
//  Copyright © 2016年 TongBuWeiYe. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

class NetDataManager: NSObject {
    static let shareNetDataManager = NetDataManager()
    fileprivate override init() {}
    let pageSize = 20
    let DoubanBaseURL = "https://api.douban.com/v2"//DoubanBaseURL
    func GETRequest(_ URLString: URLConvertible, parameters: Parameters? = nil, NetData: @escaping (_ data: Data?)->Void) {//get方法
//        HUD.show(.labeledProgress(title: "正在加载", subtitle: ""))
        Alamofire.request(URLString, method: .get, parameters: parameters).responseJSON {
            response in
            switch response.result {
            case .success:
                NetData(response.data)
                HUD.hide()
            case .failure( _):
                HUD.show(.labeledError(title: "连接服务器失败", subtitle: ""))
                HUD.hide()
            }
        }
    }
}
extension NetDataManager {
    func findBook(with name: String, NetData: @escaping (_ data: Data?)->Void) {// 搜索图书
        GETRequest("\(DoubanBaseURL)/book/search", parameters: ["q":name], NetData: NetData)
    }
    func findMovie(with name: String, NetData: @escaping (_ data: Data?)->Void) {// 搜索电影
        GETRequest("\(DoubanBaseURL)/movie/search", parameters: ["q":name], NetData: NetData)
    }
    func findDetailMovie(with movie: ZYMovie, NetData: @escaping (_ data: Data?)->Void) {// 电影条目信息
        GETRequest("\(DoubanBaseURL)/movie/subject/\(String(describing: movie.id))", NetData: NetData)
    }
    func findTheatersMovie(_ NetData: @escaping (_ data: Data?)->Void) {// 正在上映的电影
        GETRequest("\(DoubanBaseURL)/movie/in_theaters", NetData: NetData)
    }
    func findComingMovie(_ NetData: @escaping (_ data: Data?)->Void) {// 即将上映的电影
        GETRequest("\(DoubanBaseURL)/movie/coming_soon", NetData: NetData)
    }
    func findTop250Movie(_ NetData: @escaping (_ data: Data?)->Void) {// Top250的电影
        GETRequest("\(DoubanBaseURL)/movie/top250", NetData: NetData)
    }
    func findWeeklyMovie(_ NetData: @escaping (_ data: Data?)->Void) {// 口碑榜的电影
        GETRequest("\(DoubanBaseURL)/movie/weekly", NetData: NetData)
    }
    func findBoxMovie(_ NetData: @escaping (_ data: Data?)->Void) {// 北美票房榜的电影
        GETRequest("\(DoubanBaseURL)/movie/us_box", NetData: NetData)
    }
    func findNewMovie(_ NetData: @escaping (_ data: Data?)->Void) {// 新片榜的电影
        GETRequest("\(DoubanBaseURL)/movie/new_movies", NetData: NetData)
    }
}
