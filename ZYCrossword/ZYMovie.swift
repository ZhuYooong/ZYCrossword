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
    
    override static func primaryKey() -> String? {
        return "id"
    }
    convenience init(with json: JSON) {
        self.init()
        id = json["id"].stringValue
        title = json["title"].stringValue
        alt = json["alt"].stringValue
        directors = json["directors"].arrayValue.first?.stringValue
        casts = json["casts"].arrayValue.first?.stringValue
        year = json["year"].stringValue
        genres = json["genres"].arrayValue.first?.stringValue
    }
    convenience init(from detailJson: JSON) {
        self.init()
        languages = detailJson["languages"].stringValue
        countries = detailJson["countries"].arrayValue.first?.stringValue
        summary = detailJson["summary"].stringValue
    }
}
