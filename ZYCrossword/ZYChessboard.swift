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
    fileprivate var tipXArr: Array<Word> = Array()
    fileprivate var tipYArr: Array<Word> = Array()
    fileprivate var tipXdataArr: Array<ZYBaseWord> = Array()
    fileprivate var tipYdataArr: Array<ZYBaseWord> = Array()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    convenience init(with crosswordsGenerator: ZYCrosswordsGenerator) {
        self.init()
        grid = crosswordsGenerator.grid
        for result in crosswordsGenerator.resultData {
            for resultContent in crosswordsGenerator.resultContentSet {
                
            }
        }
    }
}
extension ZYChessboard {
    func printGrid() {
        for i in 0 ..< chessboardRows {
            var s = ""
            for j in 0 ..< chessboardColumns {
                s += grid![j, i]
            }
            print(s)
        }
        print("over")
    }
}
