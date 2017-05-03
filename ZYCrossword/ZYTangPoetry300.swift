//
//  ZYTangPoetry300.swift
//  ZYCrossword
//
//  Created by MAC on 2017/4/27.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import Foundation

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
}
