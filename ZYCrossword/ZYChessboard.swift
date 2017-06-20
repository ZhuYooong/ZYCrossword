//
//  ZYChessboard.swift
//  ZYCrossword
//
//  Created by MAC on 2017/5/15.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import RealmSwift

public class ZYChessboard: NSObject {
    var grid: Array2D<String>?
    var tipXArr = Array<Word>()
    var tipYArr = Array<Word>()
    var resultXArray = [ZYBaseWord]()
    var resultYArray = [ZYBaseWord]()
    
    convenience init(crosswordsGenerator: ZYCrosswordsGenerator) {
        self.init()
        grid = crosswordsGenerator.grid
        for i in 0 ..< crosswordsGenerator.resultContentArray.count {
            let word = crosswordsGenerator.resultData[i]
            let result = crosswordsGenerator.resultContentArray[i]
            result.realm?.beginWrite()
            result.isShow = true
            try! result.realm?.commitWrite()
            if word.direction == .vertical {
                tipYArr.append(word)
                resultYArray.append(result)
            }else {
                tipXArr.append(word)
                resultXArray.append(result)
            }
        }
    }
    convenience init(dictionary: NSDictionary) {
        self.init()
        grid = dictionary.object(forKey: "grid") as? Array2D<String>
        tipXArr = dictionary.object(forKey: "tipXArr") as! Array<Word>
        tipYArr = dictionary.object(forKey: "tipYArr") as! Array<Word>
        resultXArray = dictionary.object(forKey: "resultXArray") as! [ZYBaseWord]
        resultYArray = dictionary.object(forKey: "resultYArray") as! [ZYBaseWord]
    }
    func getDictionary() -> NSDictionary {
        return NSDictionary(dictionary: ["grid":grid ?? Array2D<String>(columns: chessboardColumns, rows: chessboardColumns, defaultValue: chessboardEmptySymbol), "tipXArr":tipXArr, "tipYArr":tipYArr, "resultXArray":resultXArray, "resultYArray":resultYArray])
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
