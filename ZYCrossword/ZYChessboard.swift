//
//  ZYChessboard.swift
//  ZYCrossword
//
//  Created by MAC on 2017/5/15.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit

class ZYChessboard: NSObject, NSCoding {
    var grid = Array2D()
    var tipXArr = Array<Word>()
    var tipYArr = Array<Word>()
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.grid, forKey: "grid")
        aCoder.encode(self.tipXArr, forKey: "tipXArr")
        aCoder.encode(self.tipYArr, forKey: "tipYArr")
    }
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.grid = aDecoder.decodeObject(forKey: "grid") as! Array2D
        self.tipXArr = aDecoder.decodeObject(forKey: "tipXArr") as! Array<Word>
        self.tipYArr = aDecoder.decodeObject(forKey: "tipYArr") as! Array<Word>
    }
    override init() { }
}
extension ZYChessboard {
    func printGrid() {
        for i in 0 ..< chessboardColumns {
            var s = ""
            for j in 0 ..< chessboardColumns {
                s += grid[j, i]
            }
            print(s)
        }
        print("over")
    }
}
