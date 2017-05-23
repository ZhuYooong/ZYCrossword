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
    dynamic var content_description: String? = ""
    dynamic var ISBN: String? = ""
    dynamic var name: String? = ""
    dynamic var author: String? = ""
    dynamic var price: String? = ""
    dynamic var press: String? = ""
    dynamic var score: String? = ""
    dynamic var link: String? = ""
    dynamic var author_profile: String? = ""
    dynamic var date: String? = ""
    dynamic var page: String? = ""
    dynamic var wordType = ZYBookType.Top250.rawValue
    
    override static func primaryKey() -> String? {
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
    case Top250 = "Top250"
}
