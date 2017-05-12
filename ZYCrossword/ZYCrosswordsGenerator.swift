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
    open var columns: Int = 12
    open var rows: Int = 12
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
    fileprivate var resultContentSet = Set<ZYBaseWord>()
    // MARK: - Initialization
    static let shareCrosswordsGenerator = ZYCrosswordsGenerator()
    fileprivate override init() { }
    func loadCrosswordsData() {
        let myQueue = DispatchQueue(label: "loadCrosswordsData")
        myQueue.async {
            self.loadData()
        }
        myQueue.async(group: nil, qos: .default, flags: .barrier) { 
            self.generate()
        }
    }
    // MARK: - 加载数据
    var contentArray = [AnyObject]()
    
    func loadData() {
        let allWordArray = ZYWordViewModel.shareWord.loadWordData()
        for word in allWordArray {
            if word.isSelectted == "1" {
                self.loadJsonData(with: word.wordType)
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
        }else if name == "Top250的电影" {
            contentArray.append(ZYJsonViewModel.shareJson.loadJsonData(with: ZYMovie.self).filter(NSPredicate(format: "type = '\(ZYMovieType.Top250.rawValue)'")))
        }else if name == "最近的电影" {
            contentArray.append(ZYNetwordViewModel.shareNetword.findNowMovie())
        }
    }
    // MARK: - Crosswords generation
    open func generate() {
        var isSuccess = false
        while !isSuccess {
            self.grid = nil
            self.grid = Array2D(columns: self.columns, rows: self.rows, defaultValue: self.emptySymbol)
            
            self.currentWords.removeAll()
            self.resultData.removeAll()
            self.resultContentSet.removeAll()
            self.currentContent = nil
            
            var isContininue = true
            var count = 0
            while isContininue {
                if let word = self.currentWords.last, word.length > 1 {
                    var strArray = [String]()
                    for str in word.characters {
                        strArray.append(String(str))
                    }
                    if let foundWord = self.findWord(with: strArray[self.randomInt(0, max: strArray.count - 1)]) {
                        if self.fitAndAdd(foundWord) == false {
                            count += 1
                        }
                        if count == 200 {
                            isContininue = false
                        }
                    }else {
                        isContininue = false
                    }
                }else if self.currentWords.count == 0 {
                    if let foundWord = self.findWord(with: nil) {
                        _ = self.fitAndAdd(foundWord)
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
    // MARK: findWord
    func findWord(with name: String?) -> String? {
        if contentArray.count > 1 {
            let content = contentArray[randomInt(0, max: contentArray.count - 1)]
            return findWord(with: content, and: name)
        }
        return nil
    }
    var currentContent: AnyObject?
    func findWord(with content: AnyObject, and findString: String?) -> String? {
        if let results: Results<ZYTangPoetry300> = content as? Results<ZYTangPoetry300> {
            var detailResult: ZYTangPoetry300?
            for item in filterResult(with: results, and: ZYTangPoetry300.self, and: findString) {
                if !resultContentSet.contains(item) {
                    detailResult = item
                    break
                }
            }
            if let deatil = detailResult?.detail {
                currentContent = detailResult
                return findDetailWord(with: deatil, and: findString)
            }
        }else if let results: Results<ZYSongPoetry300> = content as? Results<ZYSongPoetry300> {
            var detailResult: ZYSongPoetry300?
            for item in filterResult(with: results, and: ZYSongPoetry300.self, and: findString) {
                if !resultContentSet.contains(item) {
                    detailResult = item
                    break
                }
            }
            if let deatil = detailResult?.detail {
                currentContent = detailResult
                return findDetailWord(with: deatil, and: findString)
            }
        }else if let results: Results<ZYOldPoetry300> = content as? Results<ZYOldPoetry300> {
            var detailResult: ZYOldPoetry300?
            for item in filterResult(with: results, and: ZYOldPoetry300.self, and: findString) {
                if !resultContentSet.contains(item) {
                    detailResult = item
                    break
                }
            }
            if let deatil = detailResult?.detail {
                currentContent = detailResult
                return findDetailWord(with: deatil, and: findString)
            }
        }else if let results: Results<ZYShiJing> = content as? Results<ZYShiJing> {
            var detailResult: ZYShiJing?
            for item in filterResult(with: results, and: ZYShiJing.self, and: findString) {
                if !resultContentSet.contains(item) {
                    detailResult = item
                    break
                }
            }
            if let deatil = detailResult?.detail {
                currentContent = detailResult
                return findDetailWord(with: deatil, and: findString)
            }
        }else if let results: Results<ZYYueFu> = content as? Results<ZYYueFu> {
            var detailResult: ZYYueFu?
            for item in filterResult(with: results, and: ZYYueFu.self, and: findString) {
                if !resultContentSet.contains(item) {
                    detailResult = item
                    break
                }
            }
            if let deatil = detailResult?.detail {
                currentContent = detailResult
                return findDetailWord(with: deatil, and: findString)
            }
        }else if let results: Results<ZYChuCi> = content as? Results<ZYChuCi> {
            var detailResult: ZYChuCi?
            for item in filterResult(with: results, and: ZYChuCi.self, and: findString) {
                if !resultContentSet.contains(item) {
                    detailResult = item
                    break
                }
            }
            if let deatil = detailResult?.detail {
                currentContent = detailResult
                return findDetailWord(with: deatil, and: findString)
            }
        }else if let results: Results<ZYTangPoetryAll> = content as? Results<ZYTangPoetryAll> {
            var detailResult: ZYTangPoetryAll?
            for item in filterResult(with: results, and: ZYTangPoetryAll.self, and: findString) {
                if !resultContentSet.contains(item) {
                    detailResult = item
                    break
                }
            }
//            if let deatil = detailResult?.detail {
//            currentContent = detailResult
//                return findDetailWord(with: deatil, and: findString)
//            }
        }else if let results: Results<ZYSongPoetryAll> = content as? Results<ZYSongPoetryAll> {
            var detailResult: ZYSongPoetryAll?
            for item in filterResult(with: results, and: ZYSongPoetryAll.self, and: findString) {
                if !resultContentSet.contains(item) {
                    detailResult = item
                    break
                }
            }
//            if let deatil = detailResult?.detail {
//            currentContent = detailResult
//                return findDetailWord(with: deatil, and: findString)
//            }
        }else if let results: Results<ZYMovie> = content as? Results<ZYMovie> {
            var detailResult: ZYMovie?
            for item in filterResult(with: results, and: ZYMovie.self, and: findString) {
                if !resultContentSet.contains(item) {
                    detailResult = item
                    break
                }
            }
            if let deatil = detailResult?.title {
                currentContent = detailResult
                return findDetailWord(with: deatil, and: findString)
            }
        }
        return nil
    }
    func filterResult<T: Object>(with results: Results<T>, and type: T.Type, and findString: String?) -> Results<T> {
        if let findString = findString {
            var predicate = NSPredicate(format: "detail contains '\(findString)'")
            if type == ZYMovie.self {
                predicate = NSPredicate(format: "title contains '\(findString)'")
            }
            return results.filter(predicate).sorted(byProperty: "selecttedCount")
        }else {
            return results.sorted(byProperty: "selecttedCount")
        }
    }
    func findDetailWord(with detail:String, and findString: String?) -> String? {
        let set = CharacterSet(charactersIn: "，。！？；)")
        var detailStrArray = detail.components(separatedBy: set)
        for str in detailStrArray {
            if str == "" || str.contains("(") {
                detailStrArray.remove(object: str)
            }
        }
        if let str = findString {
            for detailString in detailStrArray {
                if detailString.contains(str) {
                    return detailString
                }
            }
        }else {
            if detailStrArray.count > 1 {
                return detailStrArray[randomInt(0, max: detailStrArray.count - 1)]
            }else {
                return detailStrArray.first
            }
        }
        return nil
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
                            if ((rowc - glc) + word.length) <= rows {
                                coordlist.append((colc, rowc - glc, 1, colc + (rowc - glc), 0))
                            }
                        }
                        if colc - glc > 0 {
                            if ((colc - glc) + word.length) <= columns {
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
            resultContentSet.insert(currentContent as! ZYBaseWord)
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
