//
//  ZYMovie.swift
//  ZYCrossword
//
//  Created by MAC on 2017/5/10.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class ZYMovie: ZYBaseWord {
    @objc dynamic var content_description = ""
    @objc dynamic var movie_name = ""
    @objc dynamic var url = ""
    @objc dynamic var direct = ""
    @objc dynamic var langrage = ""
    @objc dynamic var place = ""
    @objc dynamic var date = ""
    @objc dynamic var IMDb = ""
    @objc dynamic var type = ""
    @objc dynamic var wordType = ZYMovieType.Top250.rawValue

    override static func primaryKey() -> String {
        return "IMDb"
    }
    convenience init(with json: JSON, and typeInfo: String) {
        self.init()
        content_description = json["content_description"].stringValue
        movie_name = json["movie_name"].stringValue
        url = json["url"].stringValue
        direct = json["direct"].stringValue
        langrage = json["langrage"].stringValue
        place = json["place"].stringValue
        date = json["date"].stringValue
        IMDb = json["IMDb"].stringValue
        type = json["type"].stringValue
        wordType = typeInfo
        showString = json["movie_name"].stringValue
    }
}
enum ZYMovieType: String {
    case Top250 = "Top250的电影"
}
