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
    @objc dynamic var url: String? = ""
    @objc dynamic var content: String? = ""
    @objc dynamic var name: String? = ""
    @objc dynamic var answer: String? = ""
    @objc dynamic var wordType = ZYAllegoricType.Base.rawValue
    
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
        showString = json["name"].stringValue
    }
}
enum ZYAllegoricType: String {
    case Base = "歇后语词典"
}
