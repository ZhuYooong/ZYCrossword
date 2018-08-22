//
//  ZYCrosswordsGenerator.swift
//  ZYCrossword
//
//  Created by MAC on 2017/5/4.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import SQLite

class ZYCrosswordsGenerator: NSObject {
    static let shareCrosswordsGenerator = ZYCrosswordsGenerator()
    fileprivate override init() {}
    
    var chessboard: ZYChessboard?
    var tipXdataArr = [ZYWord]()
    var tipYdataArr = [ZYWord]()
    // MARK: - Initialization
    func loadCrosswordsData(isBackgrounding: Bool) {
        isBackground = isBackgrounding
        loadDictionaryData()
        generate()
    }
    // MARK: - 加载数据
    fileprivate var dictionaryArray = [(Row)]()
    
    func loadDictionaryData() {
        dictionaryArray.removeAll()
        let allDictionaryArray = ZYDictionaryViewModel.shareDictionary.loadDictionaryData(with: nil)
        for dictionary in allDictionaryArray {
            if dictionary[Expression<Bool>("isSelectted")] == true {
                dictionaryArray.append(dictionary)
            }
        }
    }
    // MARK: - Crosswords generation
    var isSuccess = false
    func generate() {
        if dictionaryArray.count > 1 {
            let semaphore = DispatchSemaphore(value: 5)
            while !isSuccess {
                semaphore.wait()
                DispatchQueue.global().asyncAfter(deadline: .now() + 10) {
                    let chessboardViewModel = ZYChessboardViewModel(contentArray: self.dictionaryArray)
                    chessboardViewModel.generateOnce()
                    if chessboardViewModel.currentWords.count > generateSuccessCount && !self.isSuccess {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: generateSuccessKey), object: chessboardViewModel)
                    }else {
                        semaphore.signal()
                    }
                }
            }
        }else {
            loadDictionaryData()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(generateSuccess(_:)), name: NSNotification.Name(rawValue: generateSuccessKey), object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    var isBackground: Bool = false
    func creatChessboard(chessboardViewModel: ZYChessboardViewModel) {
        chessboard = ZYChessboard()
        chessboard?.grid = chessboardViewModel.grid
        chessboard?.resultGrid = Array2D(columns: chessboardColumns, rows: chessboardColumns, defaultValue: chessboardEmptySymbol)
        tipXdataArr = [ZYWord]()
        tipYdataArr = [ZYWord]()
        for i in 0 ..< chessboardViewModel.resultContentArray.count {
            let word = chessboardViewModel.resultData[i]
            let result = chessboardViewModel.resultContentArray[i]
            
            ZYWordViewModel.shareWord.documentsDatabase.tableLampUpdateRow(with: .showBegin, word: result, show: word.word)
            if word.direction == .vertical {
                chessboard?.tipYArr.append(word)
                tipYdataArr.append(ZYWordViewModel.shareWord.formatConversionWord(with: result))
            }else {
                chessboard?.tipXArr.append(word)
                tipXdataArr.append(ZYWordViewModel.shareWord.formatConversionWord(with: result))
            }
        }
        if isBackground {
            NSKeyedArchiver.archiveRootObject(chessboard ?? ZYChessboard(), toFile: ZYCustomClass.shareCustom.anotherChessboardPath(isUpdate: false).getFilePath())
        }else {
            NSKeyedArchiver.archiveRootObject(chessboard ?? ZYChessboard(), toFile: chessboardDocumentPath.getFilePath())
        }
    }
    @objc func generateSuccess(_ notification: Notification) {
        if let chessboardViewModel = notification.object as? ZYChessboardViewModel {
            self.creatChessboard(chessboardViewModel: chessboardViewModel)
            self.isSuccess = true
        }
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
