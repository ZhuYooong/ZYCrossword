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
    dynamic var author: String? = ""
    dynamic var title: String? = ""
    dynamic var summary: String? = ""
    dynamic var url: String? = ""
    dynamic var authorIntro: String? = ""
    dynamic var image: String? = ""
    dynamic var catalog: String? = ""
    
    override static func primaryKey() -> String? {
        return "title"
    }
    convenience init(with json: JSON) {
        self.init()
        author = json["author"].arrayValue.first?.stringValue
        title = json["title"].stringValue
        summary = json["summary"].stringValue
        url = json["url"].stringValue
        authorIntro = json["author_intro"].stringValue
        image = json["image"].stringValue
        catalog = json["catalog"].stringValue
    }
}
