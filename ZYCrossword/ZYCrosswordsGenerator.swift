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
    // MARK: - Additional types
    public struct Word {
        public var word = ""
        public var column = 0
        public var row = 0
        public var direction: WordDirection = .vertical
    }
    public enum WordDirection {
        case vertical
        case horizontal
    }
    // MARK: - Public properties
    open var columns: Int = 10
    open var rows: Int = 10
    open var words: Array<String> = Array()
    
    open var result: Array<Word> {
        get {
            return resultData
        }
    }
    // MARK: - Public additional properties
    open var fillAllWords = false
    open var emptySymbol = "-"
    open var debug = true
    open var orientationOptimization = false
    // MARK: - Logic properties
    fileprivate var grid: Array2D<String>?
    fileprivate var currentWords: Array<String> = Array()
    fileprivate var resultData: Array<Word> = Array()
    // MARK: - Initialization
    static let shareCrosswordsGenerator = ZYCrosswordsGenerator()
    fileprivate override init() { }
    // MARK: - 加载数据
    var contentArray = [AnyObject]()
    
    func loadData() {
        DispatchQueue.global().async {
            let allWordArray = ZYWordViewModel.shareWord.loadWordData()
            for word in allWordArray {
                if word.isSelectted == "1" {
                    self.loadJsonData(with: word.wordType)
                }
            }
        }
    }
    func loadJsonData(with name:String?) {
        if name == "唐诗三百首" {
            contentArray.append(ZYJsonViewModel.shareJson.loadJsonData(with: ZYTangPoetry300.self))
        }else if name == "宋词三百首" {
            contentArray.append(ZYJsonViewModel.shareJson.loadJsonData(with: ZYSongPoetry300.self))
        }else if name == "古诗三百首" {
            contentArray.append(ZYJsonViewModel.shareJson.loadJsonData(with: ZYOldPoetry300.self))
        }else if name == "诗经" {
            contentArray.append(ZYJsonViewModel.shareJson.loadJsonData(with: ZYShiJing.self))
        }else if name == "乐府诗集" {
            contentArray.append(ZYJsonViewModel.shareJson.loadJsonData(with: ZYYueFu.self))
        }else if name == "楚辞" {
            contentArray.append(ZYJsonViewModel.shareJson.loadJsonData(with: ZYChuCi.self))
        }else if name == "全唐诗" {
            contentArray.append(ZYJsonViewModel.shareJson.loadJsonData(with: ZYTangPoetryAll.self))
        }else if name == "全宋词" {
            contentArray.append(ZYJsonViewModel.shareJson.loadJsonData(with: ZYSongPoetryAll.self))
        }
    }
    // MARK: - Crosswords generation
    open func generate() {
        DispatchQueue.global().async {
            var isSuccess = false
            while !isSuccess {
                self.grid = nil
                self.grid = Array2D(columns: self.columns, rows: self.rows, defaultValue: self.emptySymbol)
                
                self.currentWords.removeAll()
                self.resultData.removeAll()
                
                var isContininue = true
                while isContininue {
                    if let word = self.currentWords.last, word.length > 1 {
                        let strArray = word.components(separatedBy: "")
                        if let foundWord = self.findWord(with: strArray[self.randomInt(0, max: strArray.count - 1)]) {
                            isContininue = self.fitAndAdd(foundWord)
                        }else {
                            isContininue = false
                        }
                    }else if self.currentWords.count == 0 {
                        if let foundWord = self.findWord(with: nil) {
                            isContininue = self.fitAndAdd(foundWord)
                        }else {
                            isContininue = false
                        }
                    }else {
                        isContininue = false
                    }
                }
                if self.currentWords.count > 20 {
                    isSuccess = true
                }
            }
        }
    }
    // MARK: findWord
    func findWord(with name: String?) -> String? {
        if contentArray.count > 2 {
            let content = contentArray[randomInt(0, max: contentArray.count - 1)]
            var findString: String?
            if let str = name, str.length > 1 {
               let strArray = str.components(separatedBy: "")
               findString = strArray[randomInt(0, max: strArray.count - 1)]
            }
            return findWord(with: content, and: findString)
        }
        return nil
    }
    func findWord(with content: AnyObject, and findString: String?) -> String? {
        if let results: Results<ZYTangPoetry300> = content as? Results<ZYTangPoetry300> {
            let detailResult = filterResult(with: results, and: ZYTangPoetry300.self, and: findString).first
            if let deatil = detailResult?.detail {
                var detailStrArray = deatil.components(separatedBy: "，。（）")
                var shouldDelete = false
                for detailString in detailStrArray {
                    
                }
                if let str = findString {
                    for detailString in detailStrArray {
                        if detailString.contains(str) {
                            return str
                        }
                    }
                }else {
                    return detailStrArray[randomInt(0, max: detailStrArray.count - 1)]
                }
            }
        }
        return nil;
    }
    func filterResult<T: Object>(with results: Results<T>, and type: T.Type, and findString: String?) -> Results<T> {
        if let findString = findString {
            let predicate = NSPredicate(format: "detail contains '\(findString)'")
            return results.filter(predicate).sorted(byProperty: "selecttedCount")
        }else {
            return results.sorted(byProperty: "selecttedCount")
        }
    }
    // MARK: addWord
    fileprivate func fitAndAdd(_ word: String) -> Bool {
        var fit = false
        var count = 0
        var coordlist = suggestCoord(word)
        while !fit && count < 2000 {
            if currentWords.count == 0 {
                let direction = randomValue()
                let column = 1 + 1
                let row = 1 + 1
                if checkFitScore(column, row: row, direction: direction, word: word) > 0 {
                    fit = true
                    setWord(column, row: row, direction: direction, word: word, force: true)
                }
            }else {
                if count >= 0 && count < coordlist.count {
                    let column = coordlist[count].0
                    let row = coordlist[count].1
                    let direction = coordlist[count].2
                    
                    if coordlist[count].4 > 0 {
                        fit = true
                        setWord(column, row: row, direction: direction, word: word, force: true)
                    }
                }else {
                    return false
                }
            }
            count += 1
        }
        return true
    }
    fileprivate func suggestCoord(_ word: String) -> Array<(Int, Int, Int, Int, Int)> {
        var coordlist = Array<(Int, Int, Int, Int, Int)>()
        var glc = -1
        for letter in word.characters {
            glc += 1
            var rowc = 0
            for row: Int in 0 ..< rows {
                rowc += 1
                var colc = 0
                for column: Int in 0 ..< columns {
                    colc += 1
                    let cell = grid![column, row]
                    if String(letter) == cell {
                        if rowc - glc > 0 {
                            if ((rowc - glc) + word.lengthOfBytes(using: String.Encoding.utf8)) <= rows {
                                coordlist.append((colc, rowc - glc, 1, colc + (rowc - glc), 0))
                            }
                        }
                        if colc - glc > 0 {
                            if ((colc - glc) + word.lengthOfBytes(using: String.Encoding.utf8)) <= columns {
                                coordlist.append((colc - glc, rowc, 0, rowc + (colc - glc), 0))
                            }
                        }
                    }
                }
            }
        }
        let newCoordlist = sortCoordlist(coordlist, word: word)
        return newCoordlist
    }
    fileprivate func sortCoordlist(_ coordlist: Array<(Int, Int, Int, Int, Int)>, word: String) -> Array<(Int, Int, Int, Int, Int)> {
        var newCoordlist = Array<(Int, Int, Int, Int, Int)>()
        for var coord in coordlist {
            let column = coord.0
            let row = coord.1
            let direction = coord.2
            coord.4 = checkFitScore(column, row: row, direction: direction, word: word)
            if coord.4 > 0 {
                newCoordlist.append(coord)
            }
        }
        newCoordlist.shuffle()
        newCoordlist.sort(by: {$0.4 > $1.4})
        return newCoordlist
    }
    fileprivate func checkFitScore(_ column: Int, row: Int, direction: Int, word: String) -> Int {
        var c = column
        var r = row
        if c < 1 || r < 1 || c >= columns || r >= rows {
            return 0
        }
        var count = 1
        var score = 1
        for letter in word.characters {
            let activeCell = getCell(c, row: r)
            if activeCell == emptySymbol || activeCell == String(letter) {
                if activeCell == String(letter) {
                    score += 1
                }
                if direction == 0 {
                    if activeCell != String(letter) {
                        if !checkIfCellClear(c, row: r - 1) {
                            return 0
                        }
                        if !checkIfCellClear(c, row: r + 1) {
                            return 0
                        }
                    }
                    if count == 1 {
                        if !checkIfCellClear(c - 1, row: r) {
                            return 0
                        }
                    }
                    if count == word.lengthOfBytes(using: String.Encoding.utf8) {
                        if !checkIfCellClear(c + 1, row: row) {
                            return 0
                        }
                    }
                }else {
                    if activeCell != String(letter) {
                        if !checkIfCellClear(c + 1, row: r) {
                            return 0
                        }
                        if !checkIfCellClear(c - 1, row: r) {
                            return 0
                        }
                    }
                    if count == 1 {
                        if !checkIfCellClear(c, row: r - 1) {
                            return 0
                        }
                    }
                    if count == word.lengthOfBytes(using: String.Encoding.utf8) {
                        if !checkIfCellClear(c, row: r + 1) {
                            return 0
                        }
                    }
                }
                if direction == 0 {
                    c += 1
                }else {
                    r += 1
                }
                if (c >= columns || r >= rows) {
                    return 0
                }
                count += 1
            }else {
                return 0
            }
        }
        return score
    }
    func setCell(_ column: Int, row: Int, value: String) {
        grid![column - 1, row - 1] = value
    }
    func getCell(_ column: Int, row: Int) -> String{
        return grid![column - 1, row - 1]
    }
    func checkIfCellClear(_ column: Int, row: Int) -> Bool {
        if column > 0 && row > 0 && column < columns && row < rows {
            return getCell(column, row: row) == emptySymbol ? true : false
        }else {
            return true
        }
    }
    fileprivate func setWord(_ column: Int, row: Int, direction: Int, word: String, force: Bool = false) {
        if force {
            let w = Word(word: word, column: column, row: row, direction: (direction == 0 ? .horizontal : .vertical))
            resultData.append(w)
            currentWords.append(word)
            var c = column
            var r = row
            for letter in word.characters {
                setCell(c, row: r, value: String(letter))
                if direction == 0 {
                    c += 1
                }else {
                    r += 1
                }
            }
        }
    }
    // MARK: - Misc
    fileprivate func randomValue() -> Int {
        if orientationOptimization {
            return UIDevice.current.orientation.isLandscape ? 1 : 0
        }else {
            return randomInt(0, max: 1)
        }
    }
    fileprivate func randomInt(_ min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
}