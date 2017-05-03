//
//  ZYYueFu.swift
//  
//
//  Created by MAC on 2017/5/3.
//
//

import UIKit

class ZYYueFu: ZYBaseWord {
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
