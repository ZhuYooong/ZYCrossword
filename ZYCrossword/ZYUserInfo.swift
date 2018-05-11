//
//  ZYUserInfo.swift
//  ZYCrossword
//
//  Created by MAC on 2017/9/26.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit

class ZYUserInfo: Object {
    @objc dynamic var userIdentifier: String = ""
    @objc dynamic var starCount: Int = 0
    @objc dynamic var coinCount: Int = 0
    
    override static func primaryKey() -> String {
        return "userIdentifier"
    }
}
