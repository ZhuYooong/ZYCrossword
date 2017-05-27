//
//  ZYWord.swift
//  ZYCrossword
//
//  Created by MAC on 2017/4/27.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import Foundation
import RealmSwift
class ZYWord: Object {
    dynamic var isSelectted: Bool = false
    dynamic var wordType: String = ""
    
    override static func primaryKey() -> String {
        return "wordType"
    }
}
