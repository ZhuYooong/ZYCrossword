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
    dynamic var selecttedCount: Int = 0
    dynamic var isCollect: Bool = false
}