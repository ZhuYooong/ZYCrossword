//
//  ZYBaseWord.swift
//  ZYCrossword
//
//  Created by MAC on 2017/4/28.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import Foundation
import RealmSwift
class ZYBaseWord: Object {
    @objc dynamic var selecttedCount = 0
    @objc dynamic var isCollect = false
    @objc dynamic var collectDate = Date()
    @objc dynamic var isRight = false
    @objc dynamic var isShow = false
    @objc dynamic var showString = ""
}
