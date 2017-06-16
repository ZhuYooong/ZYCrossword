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
    dynamic var url: String? = ""
    dynamic var enunciation: String? = ""
    dynamic var paraphrase: String? = ""
    dynamic var derivation: String? = ""
    dynamic var title: String? = ""
    dynamic var wordType = ZYIdiomType.Base.rawValue
    
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
