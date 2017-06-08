//
//  ZYAllegoric.swift
//  ZYCrossword
//
//  Created by MAC on 2017/6/6.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class ZYAllegoric: ZYBaseWord {
    dynamic var url: String? = ""
    dynamic var content: String? = ""
    dynamic var name: String? = ""
    dynamic var answer: String? = ""
    dynamic var wordType = ZYAllegoricType.Base.rawValue
    
    override static func primaryKey() -> String {
        return "url"
    }
    convenience init(with json: JSON, and typeInfo: String) {
        self.init()
        content = json["content"].stringValue
        url = json["url"].stringValue
        name = json["name"].stringValue
        answer = json["answer"].stringValue
        wordType = typeInfo
    }
}
enum ZYAllegoricType: String {
    case Base = "歇后语词典"
}
