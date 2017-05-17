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
    dynamic var content_description: String? = ""
    dynamic var movie_name: String? = ""
    dynamic var url: String? = ""
    dynamic var direct: String? = ""
    dynamic var langrage: String? = ""
    dynamic var place: String? = ""
    dynamic var date: String? = ""
    dynamic var IMDb: String? = ""
    dynamic var type: String? = ""
    
    override static func primaryKey() -> String? {
        return "IMDb"
    }
    convenience init(with json: JSON) {
        self.init()
        content_description = json["content_description"].stringValue
        movie_name = json["movie_name"].stringValue
        url = json["url"].stringValue
        direct = json["direct"].arrayValue.first?.stringValue
        langrage = json["langrage"].arrayValue.first?.stringValue
        place = json["place"].stringValue
        date = json["date"].arrayValue.first?.stringValue
        IMDb = json["IMDb"].stringValue
        type = json["type"].arrayValue.first?.stringValue
    }
}
