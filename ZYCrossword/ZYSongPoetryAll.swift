//
//  ZYSongPoetryAll.swift
//  ZYCrossword
//
//  Created by MAC on 2017/4/27.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import Foundation

class ZYSongPoetryAll: ZYBaseWord {
    dynamic var userId: String? = ""
    dynamic var userName: String? = ""
    dynamic var levelName: String? = ""
    dynamic var photo: String? = ""
    dynamic var userCode: String? = ""
    dynamic var department: String? = ""
    dynamic var departmentType: String? = ""
    dynamic var mobileTel: String? = ""
    dynamic var level: String? = ""
    dynamic var reportId: String? = ""
    dynamic var reportName: String? = ""
    dynamic var isAttented: String? = ""
    
    override static func primaryKey() -> String? {
        return "userId"
    }
}
