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
    
    open var orientationOptimization = false
    // MARK: - Logic properties
    open var grid: Array2D?
    open var resultData: Array<Word> = Array<Word>()
    open var resultContentArray: Array<ZYBaseWord> = Array<ZYBaseWord>()
    // MARK: - Initialization
    func loadCrosswordsData() {
        let realm = try! Realm()
        loadData(with: realm)
        generate()
    }
    // MARK: - 加载数据
    fileprivate var contentArray = [AnyObject]()
    fileprivate var resultContentSet: Set<ZYBaseWord> = Set<ZYBaseWord>()
    fileprivate var currentWords: Array<String> = Array<String>()
    
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
    let columns: Int = { () -> Int in
        return Int((screenWidth - 44) / 33)
    }()
    var emptySymbol = "-"
    open func generate() {
        var isSuccess = false
        while !isSuccess {
            grid = Array2D(columns: columns, rows: columns, defaultValue: emptySymbol)
            resultData.removeAll()
            resultContentArray.removeAll()
            
            currentContent = nil
            currentWords.removeAll()
            resultContentSet.removeAll()
            generateOnce()
            if currentWords.count > 10 {
                isSuccess = true
            }
        }
    }
    func generateOnce() {
        var isContininue = true
        var count = 0
        var oldFindWord = ""
        while isContininue {
            if currentWords.count == 0 {
                if findWord(with: nil) == false {
                    count += 1
                }
            }else {
                if let selectedWord = generateAnother(word: currentWords[randomInt(0, max: currentWords.count - 1)], oldFindWord: oldFindWord) {
                    oldFindWord = selectedWord
                }else {
                    count += 1
                }
            }
            if count == 200 {
                isContininue = false
            }
        }
    }
    func generateAnother(word: String, oldFindWord: String) -> String? {// 添加词
        if word.count > 1 {
            var selectedWord = ""
            var strArray = [String]()
            for str in word {
                strArray.append(String(str))
            }
            var isRepeat = true
            while isRepeat {
                let findWord = strArray[randomInt(0, max: strArray.count - 1)]
                if findWord != oldFindWord {
                    selectedWord = findWord
                    isRepeat = false
                }
            }
            if findWord(with: selectedWord) == false {
                return nil
            }
            return selectedWord
        }else {
            return nil
        }
    }
    // MARK: findWord
    func findWord(with name: String?) -> Bool {
        if contentArray.count > 1 {
            var thisContentArray = contentArray
            var isFail = false
            while !isFail {
                let index = randomInt(0, max: thisContentArray.count - 1)
                let content = thisContentArray[index]
                if findWord(with: content, and: name) == true {
                    return true
                }else {
                    if thisContentArray.count == 1 {
                        isFail = true
                    }else {
                        thisContentArray.remove(at: index)
                    }
                }
            }
        }else {
            let realm = try! Realm()
            loadData(with: realm)
        }
        return false
    }
    var currentContent: AnyObject?
    func findWord(with content: AnyObject, and findString: String?) -> Bool {
        if let results: Results<ZYPoetry> = content as? Results<ZYPoetry> {
            for item in filterResult(with: results, and: ZYPoetry.self, and: findString) {
                if !resultContentSet.contains(item) {
                    currentContent = item
                    if let foundWord = findDetailWord(with: item.detail, and: findString, isPoetry: true) {
                        if fitAndAdd(foundWord) == true {
                            return true
                        }
                    }
                }
            }
        }else if let results: Results<ZYMovie> = content as? Results<ZYMovie> {
            for item in filterResult(with: results, and: ZYMovie.self, and: findString) {
                if !resultContentSet.contains(item) {
                    currentContent = item
                    if let foundWord = findDetailWord(with: item.movie_name, and: findString, isPoetry: false) {
                        if fitAndAdd(foundWord) == true {
                            return true
                        }
                    }
                }
            }
        }else if let results: Results<ZYBook> = content as? Results<ZYBook> {
            for item in filterResult(with: results, and: ZYBook.self, and: findString) {
                if !resultContentSet.contains(item) {
                    currentContent = item
                    if let foundWord = findDetailWord(with: item.name, and: findString, isPoetry: false) {
                        if fitAndAdd(foundWord) == true {
                            return true
                        }
                    }
                }
            }
        }else if let results: Results<ZYIdiom> = content as? Results<ZYIdiom> {
            for item in filterResult(with: results, and: ZYIdiom.self, and: findString) {
                if !resultContentSet.contains(item) {
                    currentContent = item
                    if let foundWord = findDetailWord(with: item.title ?? "", and: findString, isPoetry: false) {
                        if fitAndAdd(foundWord) == true {
                            return true
                        }
                    }
                }
            }
        }else if let results: Results<ZYAllegoric> = content as? Results<ZYAllegoric> {
            for item in filterResult(with: results, and: ZYAllegoric.self, and: findString) {
                if !resultContentSet.contains(item) {
                    currentContent = item
                    if let foundWord = findDetailWord(with: item.name ?? "", and: findString, isPoetry: false) {
                        if fitAndAdd(foundWord) == true {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    func filterResult<T: Object>(with results: Results<T>, and type: T.Type, and findString: String?) -> Results<T> {
        if let findString = findString {
            return results.filter(NSPredicate(format: "showString contains '\(findString)'")).sorted(byKeyPath: "selecttedCount").sorted(byKeyPath: "isCollect")
        }else {
            return results.sorted(byKeyPath: "selecttedCount").sorted(byKeyPath: "isCollect")
        }
    }
    func findDetailWord(with detail:String, and findString: String?, isPoetry: Bool) -> String? {
        let set = CharacterSet(charactersIn: "，。！？；)")
        var detailStrArray = detail.components(separatedBy: set)
        var detailStr = ""
        for str in detailStrArray {
            if str == "" || str.contains("(") {
                detailStrArray.remove(object: str)
            }else if !isPoetry {
                detailStr.append(str)
            }
        }
        if !isPoetry {
            detailStrArray = [detailStr]
        }
        if let str = findString {
            for detailString in detailStrArray {
                if currentWords.count > 1 {
                    if detailString.contains(str) && !currentWords.contains(detailString) {
                        return detailString
                    }
                }else if currentWords.count == 1 {
                    if String(detailString.first!) == str && !currentWords.contains(detailString) {
                        return detailString
                    }
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
        if currentWords.count == 0 {
            let direction = randomValue()
            let column = 1
            let row = 1
            if checkFitScore(column, row: row, direction: direction, word: word) > 0 {
                setWord(column, row: row, direction: direction, word: word, force: true)
            }
            return true
        }else {
            var fit = false
            var count = 0
            var coordlist = suggestCoord(word)
            while !fit && count < coordlist.count {
                let column = coordlist[count].0
                let row = coordlist[count].1
                let direction = coordlist[count].2
                
                if coordlist[count].4 > 0 {
                    fit = true
                    setWord(column, row: row, direction: direction, word: word, force: true)
                }
                count += 1
            }
            return false
        }
    }
    fileprivate func suggestCoord(_ word: String) -> Array<(Int, Int, Int, Int, Int)> {
        var coordlist = Array<(Int, Int, Int, Int, Int)>()
        var glc = -1
        for letter in word {
            glc += 1
            var rowc = 0
            for row: Int in 0 ..< columns {
                rowc += 1
                var colc = 0
                for column: Int in 0 ..< columns {
                    colc += 1
                    let cell = grid![column, row]
                    if String(letter) == cell {
                        if rowc - glc > 0 {
                            if ((rowc - glc) + word.count) <= columns {
                                coordlist.append((colc, rowc - glc, 1, colc + (rowc - glc), 0))
                            }
                        }
                        if colc - glc > 0 {
                            if ((colc - glc) + word.count) <= columns {
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
        if coordlist.count > 0 {
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
        }
        return newCoordlist
    }
    fileprivate func checkFitScore(_ column: Int, row: Int, direction: Int, word: String) -> Int {
        var c = column
        var r = row
        if c < 1 || r < 1 || c >= columns || r >= columns {
            return 0
        }
        var count = 1
        var score = 1
        for letter in word {
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
                if (c >= columns || r >= columns) {
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
        if column > 0 && row > 0 && column < columns && row < columns {
            return getCell(column, row: row) == emptySymbol ? true : false
        }else {
            return true
        }
    }
    fileprivate func setWord(_ column: Int, row: Int, direction: Int, word: String, force: Bool = false) {
        if force {
            var c = column
            var r = row
            var grid = [Array<Int>]()
            for letter in word {
                setCell(c, row: r, value: String(letter))
                grid.append([c - 1, r - 1])
                if direction == 0 {
                    c += 1
                }else {
                    r += 1
                }
            }
            let w = Word(word: word, column: column, row: row, direction: (direction == 0 ? .horizontal : .vertical), grid: grid)
            resultData.append(w)
            resultContentSet.insert(currentContent as! ZYBaseWord)
            resultContentArray.append(currentContent as! ZYBaseWord)
            currentWords.append(word)
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
    override init() {
        
    }
}
public enum WordDirection: Int {
    case vertical = 0
    case horizontal = 1
}
