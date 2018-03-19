//
//  ZYCrosswordsGenerator.swift
//  ZYCrossword
//
//  Created by MAC on 2017/5/4.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import RealmSwift

class ZYCrosswordsGenerator: NSObject {
    static let shareCrosswordsGenerator = ZYCrosswordsGenerator()
    fileprivate override init() {}
    
    var chessboard: ZYChessboard?
    var tipXdataArr = [ZYBaseWord]()
    var tipYdataArr = [ZYBaseWord]()
    // MARK: - Initialization
    func loadCrosswordsData() {
        let realm = try! Realm()
        loadData(with: realm)
        generate()
    }
    // MARK: - 加载数据
    fileprivate var contentArray = [AnyObject]()
    
    func loadData(with realm: Realm) {
        contentArray.removeAll()
        let allWordArray = ZYWordViewModel.shareWord.loadWordData(with: realm)
        for word in allWordArray {
            if word.isSelectted == true {
                self.loadJsonData(with: word.wordType, and: realm)
            }
        }
    }
    func loadJsonData(with name:String?, and realm: Realm) {
        if name == "唐诗三百首" || name == "宋词三百首" || name == "古诗三百首" || name == "诗经" || name == "乐府诗集" || name == "楚辞" || name == "全唐诗" || name == "全宋词" {
            contentArray.append(ZYJsonViewModel.shareJson.loadJsonData(with: ZYPoetry.self, and: name, and: realm))
        }else if name == "Top250的电影" {
            contentArray.append(ZYJsonViewModel.shareJson.loadJsonData(with: ZYMovie.self, and: name, and: realm))
        }else if name == "Top250的图书" {
            contentArray.append(ZYJsonViewModel.shareJson.loadJsonData(with: ZYBook.self, and: name, and: realm))
        }else if name == "汉语成语词典" {
            contentArray.append(ZYJsonViewModel.shareJson.loadJsonData(with: ZYIdiom.self, and: name, and: realm))
        }else if name == "歇后语词典" {
            contentArray.append(ZYJsonViewModel.shareJson.loadJsonData(with: ZYAllegoric.self, and: name, and: realm))
        }
    }
    // MARK: - Crosswords generation
    var isSuccess = false
    open func generate() {
        DispatchQueue.global().sync {
            
        }
        if contentArray.count > 1 {
            while !isSuccess {
                let chessboardViewModel = ZYChessboardViewModel(contentArray: contentArray)
                chessboardViewModel.generateOnce()
                if chessboardViewModel.currentWords.count > 10 {
                    creatChessboard(chessboardViewModel: chessboardViewModel)
                    isSuccess = true
                }
            }
        }else {
            let realm = try! Realm()
            loadData(with: realm)
        }
    }
    func creatChessboard(chessboardViewModel: ZYChessboardViewModel) {
        chessboard = ZYChessboard()
        chessboard?.grid = chessboardViewModel.grid
        chessboard?.resultGrid = Array2D(columns: chessboardColumns, rows: chessboardColumns, defaultValue: chessboardEmptySymbol)
        tipXdataArr = [ZYBaseWord]()
        tipYdataArr = [ZYBaseWord]()
        for i in 0 ..< chessboardViewModel.resultContentArray.count {
            let word = chessboardViewModel.resultData[i]
            let result = chessboardViewModel.resultContentArray[i]
            result.realm?.beginWrite()
            result.isShow = true
            if result.isKind(of: ZYPoetry.self) {
                result.showString = word.word
            }
            try! result.realm?.commitWrite()
            if word.direction == .vertical {
                chessboard?.tipYArr.append(word)
                tipYdataArr.append(result)
            }else {
                chessboard?.tipXArr.append(word)
                tipXdataArr.append(result)
            }
        }
        NSKeyedArchiver.archiveRootObject(chessboard ?? ZYChessboard(), toFile: chessboardDocumentPath.getFilePath())
    }
}
// MARK: - Additional types
public class Word: NSObject, NSCoding {
    public var word = ""
    public var column = 0
    public var row = 0
    public var direction: WordDirection = .vertical
    public var grid = [[0, 0]]
    
    convenience init(word: String, column: Int, row: Int, direction: WordDirection, grid: [Array<Int>]) {
        self.init()
        self.word = word
        self.column = column
        self.row = row
        self.direction = direction
        self.grid = grid
    }
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.word, forKey: "word")
        aCoder.encode(NSNumber(value: self.column), forKey: "column")
        aCoder.encode(NSNumber(value: self.row), forKey: "row")
        aCoder.encode(NSNumber(value: self.direction.rawValue), forKey: "direction")
        aCoder.encode(self.grid, forKey: "grid")
    }
    required public init(coder aDecoder: NSCoder) {
        super.init()
        self.word = aDecoder.decodeObject(forKey: "word") as! String
        self.column = aDecoder.decodeObject(forKey: "column") as! Int
        self.row = aDecoder.decodeObject(forKey: "row") as! Int
        self.direction = WordDirection(rawValue: (aDecoder.decodeObject(forKey: "direction") as! Int)) ?? .vertical
        self.grid = aDecoder.decodeObject(forKey: "grid") as! [Array<Int>]
    }
    override init() { }
}
public enum WordDirection: Int {
    case vertical = 0
    case horizontal = 1
}
