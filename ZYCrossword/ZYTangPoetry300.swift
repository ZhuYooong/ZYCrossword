//
//  ZYTangPoetry300.swift
//  ZYCrossword
//
//  Created by MAC on 2017/4/27.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class ZYTangPoetry300: ZYBaseWord {
    dynamic var author: String? = ""
    dynamic var background: String? = ""
    dynamic var title: String? = ""
    dynamic var detail: String? = ""
    dynamic var url: String? = ""
    dynamic var translate: String? = ""
    dynamic var appreciation: String? = ""
    dynamic var note: String? = ""
    
    override static func primaryKey() -> String? {
        return "title"
    }
    convenience init(with json: JSON) {
        self.init()
        author = json["detail_author"].arrayValue.first?.stringValue
        background = json["detail_background_text"].arrayValue.first?.stringValue
        title = json["title"].stringValue
        detail = json["detail_text"].stringValue
        url = json["url"].stringValue
        appreciation = json["detail_appreciation_text"].arrayValue.first?.stringValue
        let translateAndNoteArray = json["detail_translate_text"].arrayValue
        var translateString = ""
        var noteString = ""
        var isTranslateOrNote = 0
        for translateOrNote in translateAndNoteArray {
            if isTranslateOrNote == 2 {//注释
                if translateOrNote.stringValue[translateOrNote.stringValue.startIndex] == "(" {
                    noteString += "\n\(translateOrNote.stringValue)"
                }else {
                    noteString += translateOrNote.stringValue
                }
            }
            if translateOrNote.stringValue == "注释" {
                isTranslateOrNote = 2
            }
            if isTranslateOrNote == 1 {//译文
                translateString += translateOrNote.stringValue
            }
            if translateOrNote.stringValue == "译文" {
                isTranslateOrNote = 1
            }
        }
        note = translateString
        translate = noteString
    }
}
