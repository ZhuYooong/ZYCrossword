//
//  ZYChessboard.swift
//  ZYCrossword
//
//  Created by MAC on 2017/5/15.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import RealmSwift

public class ZYChessboard: Object {
    dynamic var id: String? = ""
    open var grid: Array2D<String>?
    open var tipXArr = Array<Word>()
    open var tipYArr = Array<Word>()
    override public static func primaryKey() -> String? {
        return "id"
    }
}
extension ZYChessboard {
    func printGrid() {
        for i in 0 ..< chessboardColumns {
            var s = ""
            for j in 0 ..< chessboardColumns {
                s += grid![j, i]
            }
            print(s)
        }
        print("over")
    }
}
