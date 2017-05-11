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
    dynamic var id: String? = ""
    dynamic var title: String? = ""
    dynamic var alt: String? = ""
    dynamic var directors: String? = ""
    dynamic var casts: String? = ""
    dynamic var year: String? = ""
    dynamic var languages: String? = ""
    dynamic var genres: String? = ""
    dynamic var countries: String? = ""
    dynamic var summary: String? = ""
    dynamic var type = ZYMovieType.Base.rawValue
    
    override static func primaryKey() -> String? {
        return "id"
    }
    convenience init(base json: JSON) {//搜索电影
        self.init()
        id = json["id"].stringValue
        title = json["title"].stringValue
        alt = json["alt"].stringValue
        directors = json["directors"].arrayValue.first?.stringValue
        casts = json["casts"].arrayValue.first?.stringValue
        year = json["year"].stringValue
        genres = json["genres"].arrayValue.first?.stringValue
    }
    convenience init(save json: JSON, and typeInfo: String) {//存储电影
        self.init()
        id = json["id"].stringValue
        title = json["title"].stringValue
        alt = json["alt"].stringValue
        directors = json["directors"].arrayValue.first?.dictionaryValue["name"]?.stringValue
        casts = json["casts"].arrayValue.first?.dictionaryValue["name"]?.stringValue
        year = json["year"].stringValue
        genres = json["genres"].arrayValue.first?.stringValue
        type = typeInfo
    }
    convenience init(detail json: JSON) {//电影详情
        self.init()
        languages = json["languages"].stringValue
        countries = json["countries"].arrayValue.first?.stringValue
        summary = json["summary"].stringValue
    }
}
enum ZYMovieType: String {
    case Base = "电影"
    case Theaters = "正在上映"
    case Coming = "即将上映"
    case Top250 = "Top250"
    case Weekly = "口碑榜"
    case Box = "北美票房榜"
    case New = "新片榜"
}
