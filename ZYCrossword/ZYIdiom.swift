//
//  ZYIdiom.swift
//  ZYCrossword
//
//  Created by MAC on 2017/5/17.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class ZYIdiom: ZYBaseWord {
    @objc dynamic var url: String? = ""
    @objc dynamic var enunciation: String? = ""
    @objc dynamic var paraphrase: String? = ""
    @objc dynamic var derivation: String? = ""
    @objc dynamic var title: String? = ""
    @objc dynamic var wordType = ZYIdiomType.Base.rawValue
    
    override static func primaryKey() -> String {
        return "title"
    }
    convenience init(with json: JSON, and typeInfo: String) {
        self.init()
        title = json["title"].stringValue
        url = json["url"].stringValue
        enunciation = json["enunciation"].stringValue
        paraphrase = json["paraphrase"].stringValue
        derivation = json["derivation"].stringValue
        wordType = typeInfo
        showString = json["title"].stringValue
    }
}
enum ZYIdiomType: String {
    case Base = "汉语成语词典"
}
