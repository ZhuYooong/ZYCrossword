//
//  ZYPoetry.swift
//  ZYCrossword
//
//  Created by MAC on 2017/5/18.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import RealmSwift

class ZYPoetry: ZYBaseWord {
    dynamic var detail = ""
    dynamic var title = ""
    dynamic var url = ""
    dynamic var translate = ""
    dynamic var note = ""
    dynamic var author = ""
    dynamic var appreciation = ""
    dynamic var dynasty = ""
    dynamic var background = ""
    dynamic var wordType = ZYPoetryType.TangPoetry300.rawValue
    
    override static func primaryKey() -> String {
        return "title"
    }
    convenience init(with json: JSON, and typeInfo: String) {
        self.init()
        author = (json["detail_author"].arrayValue.first ?? "").stringValue
        background = (json["detail_background_text"].arrayValue.first ?? "").stringValue
        title = json["title"].stringValue
        detail = json["detail_text"].stringValue
        url = json["url"].stringValue
        dynasty = json["detail_dynasty"].stringValue
        appreciation = (json["detail_appreciation_text"].arrayValue.first ?? "").stringValue
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
        wordType = typeInfo
        showString = json["detail_text"].stringValue
    }
}
enum ZYPoetryType: String {
    case TangPoetry300 = "唐诗三百首"
    case SongPoetry300 = "宋词三百首"
    case OldPoetry300 = "古诗三百首"
    case ShiJing = "诗经"
    case YueFu = "乐府诗集"
    case ChuCi = "楚辞"
    case TangPoetryAll = "全唐诗"
    case SongPoetryAll = "全宋词"
}
