//
//  ZYChessboard.swift
//  ZYCrossword
//
//  Created by MAC on 2017/5/15.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import RealmSwift

class ZYChessboard: Object {
    dynamic var id: String? = ""
    fileprivate var grid: Array2D<String>?
    fileprivate var currentWords: Array<String> = Array()
    fileprivate var resultData: Array<Word> = Array()
    fileprivate var resultContentSet = Set<ZYBaseWord>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
