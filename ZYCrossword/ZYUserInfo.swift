//
//  ZYUserInfo.swift
//  ZYCrossword
//
//  Created by MAC on 2017/9/26.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import RealmSwift
class ZYUserInfo: Object {
    dynamic var userIdentifier: String = ""
    dynamic var starCount: Int = 0
    dynamic var coinCount: Int = 0
    
    override static func primaryKey() -> String {
        return "userIdentifier"
    }
}
