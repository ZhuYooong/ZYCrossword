//
//  ZYMusic.swift
//  ZYCrossword
//
//  Created by MAC on 2017/5/11.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class ZYMusic: ZYBaseWord {
    dynamic var id = ""
    dynamic var singer = ""
    dynamic var title = ""
    dynamic var version = ""
    dynamic var alt = ""
    dynamic var pubdate = ""
    dynamic var tracks = ""
    
    override static func primaryKey() -> String {
        return "id"
    }
    convenience init(with json: JSON) {
        self.init()
        id = json["id"].stringValue
        singer = (json["attrs"].dictionaryValue["singer"] ?? "").stringValue
        title = json["title"].stringValue
        version = (json["attrs"].dictionaryValue["version"] ?? "").stringValue
        alt = json["alt"].stringValue
        pubdate = (json["attrs"].dictionaryValue["pubdate"] ?? "").stringValue
        tracks = (json["attrs"].dictionaryValue["tracks"] ?? "").stringValue
    }
}
