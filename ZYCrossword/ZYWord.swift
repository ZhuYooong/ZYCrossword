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
    @objc dynamic var isSelectted: Bool = false
    @objc dynamic var isUnlocked: Bool = false
    @objc dynamic var wordType: String = ""
    @objc dynamic var number: Int = 0
    @objc dynamic var price: Int = 0
    
    override static func primaryKey() -> String {
        return "wordType"
    }
}
