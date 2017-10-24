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
    @objc dynamic var content_description = ""
    @objc dynamic var ISBN = ""
    @objc dynamic var name = ""
    @objc dynamic var author = ""
    @objc dynamic var price = ""
    @objc dynamic var press = ""
    @objc dynamic var score = ""
    @objc dynamic var link = ""
    @objc dynamic var author_profile = ""
    @objc dynamic var date = ""
    @objc dynamic var page = ""
    @objc dynamic var wordType = ZYBookType.Top250.rawValue
    
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
        showString = json["name"].stringValue
    }
}
enum ZYBookType: String {
    case Top250 = "Top250的图书"
}
