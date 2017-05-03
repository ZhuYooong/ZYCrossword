//
//  ZYOldPoetry300.swift
//  ZYCrossword
//
//  Created by MAC on 2017/4/27.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import Foundation

class ZYOldPoetry300: ZYBaseWord {
    dynamic var detail: String? = ""
    dynamic var title: String? = ""
    dynamic var url: String? = ""
    dynamic var translate: String? = ""
    dynamic var note: String? = ""
    dynamic var author: String? = ""
    dynamic var appreciation: String? = ""
    dynamic var dynasty: String? = ""
    dynamic var background: String? = ""
    
    override static func primaryKey() -> String? {
        return "title"
    }
}
