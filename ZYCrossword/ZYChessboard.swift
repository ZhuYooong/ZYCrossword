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
    open var grid: Array2D<String>?
    open var tipXArr = Array<Word>()
    open var tipYArr = Array<Word>()
//    open var tipXdataArr = Array<ZYBaseWord>()
//    open var tipYdataArr = Array<ZYBaseWord>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    convenience init(with crosswordsGenerator: ZYCrosswordsGenerator) {
        self.init()
        grid = crosswordsGenerator.grid
        for i in 0 ..< crosswordsGenerator.resultContentArray.count {
            let word = crosswordsGenerator.resultData[i]
            let result = crosswordsGenerator.resultContentArray[i]
            if word.direction == .vertical {
                tipYArr.append(word)
//                tipYdataArr.append(result)
            }else {
                tipXArr.append(word)
//                tipXdataArr.append(result)
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
