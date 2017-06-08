//
//  ZYBook.swift
//  ZYCrossword
//
//  Created by MAC on 2017/5/10.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class ZYBook: ZYBaseWord {
    dynamic var content_description = ""
    dynamic var ISBN = ""
    dynamic var name = ""
    dynamic var author = ""
    dynamic var price = ""
    dynamic var press = ""
    dynamic var score = ""
    dynamic var link = ""
    dynamic var author_profile = ""
    dynamic var date = ""
    dynamic var page = ""
    dynamic var wordType = ZYBookType.Top250.rawValue
    
    override static func primaryKey() -> String {
        return "ISBN"
    }
    convenience init(with json: JSON, and typeInfo: String) {
        self.init()
        content_description = json["content_description"].stringValue
        ISBN = json["ISBN"].stringValue
        name = json["name"].stringValue
        author = json["author"].stringValue
        price = json["price"].stringValue
        press = json["press"].stringValue
        score = json["score"].stringValue
        link = json["link"].stringValue
        author_profile = json["author_profile"].stringValue
        date = json["date"].stringValue
        page = json["page"].stringValue
        wordType = typeInfo
    }
}
enum ZYBookType: String {
    case Top250 = "Top250的图书"
}
