//
//  ZYChessboardViewModel.swift
//  ZYCrossword
//
//  Created by 朱勇 on 2018/3/19.
//  Copyright © 2018年 ZhuYong. All rights reserved.
//

import UIKit
import SQLite

class ZYChessboardViewModel: NSObject {
    var dictionaryArray = [(Row)]()
    convenience init(contentArray: [(Row)]) {
        self.init()
        self.dictionaryArray = contentArray
        NotificationCenter.default.addObserver(self, selector: #selector(generateSuccess), name: NSNotification.Name(rawValue: generateSuccessKey), object: nil)
    }
    override init() { }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // MARK: - 加载数据
    var currentWords: Array<String> = Array<String>()
    // MARK: - Logic properties
    open var grid: Array2D = Array2D(columns: chessboardColumns, rows: chessboardColumns, defaultValue: chessboardEmptySymbol)
    open var resultData: Array<Word> = Array<Word>()
    open var resultContentArray: Array<Row> = Array<Row>()
    // MARK: - Crosswords generation
    func generateOnce() {
        var isContininue = true
        var count = 0
        var oldFindWord = ""
        while isContininue {
            if isSuccess {
                count = 200
            }
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
        var thisContentArray = dictionaryArray
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
        return false
    }
    var currentContent: Row?
    var loadedWordType = ZYLoadedWordType.ShowString
    func findWord(with content: Row, and findString: String?) -> Bool {
        loadedWordType = ZYLoadedWordType.allValues[randomValue()]
        for item in ZYWordViewModel.shareWord.loadWordData(with: content[Expression<String>("wordType")], findString: findString, loadedWordType: loadedWordType) {
            if !resultContentArray.containsContent(obj: item) && authorWhether(with: item) {
                currentContent = item
                if let foundWord = findDetailWord(with: item[Expression<String>(loadedWordType.rawValue)], and: findString, isPoetry: isPoetry(with: item)) {
                    if fitAndAdd(foundWord) == true {
                        return true
                    }
                }
            }
        }
        return false
    }
    func authorWhether(with word: Row) -> Bool {
        let author = word[Expression<String>("author")]
        if loadedWordType == .Author && (author.count <= 0 || author == "不详" || author == "无名氏" || author == "佚名") {
            return false
        }else {
            return true
        }
    }
    func isPoetry(with word: Row) -> Bool {
        if loadedWordType == .ShowString && ZYDictionaryType.specificPoetryValues.containsContent(obj: word[Expression<String>("wordType")]) {
            return true
        }else {
            return false
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
            for row: Int in 0 ..< chessboardColumns {
                rowc += 1
                var colc = 0
                for column: Int in 0 ..< chessboardColumns {
                    colc += 1
                    autoreleasepool {
                        let cell = grid[column, row]
                        if String(letter) == cell {
                            if rowc - glc > 0 {
                                if ((rowc - glc) + word.count) <= chessboardColumns {
                                    coordlist.append((colc, rowc - glc, 1, colc + (rowc - glc), 0))
                                }
                            }
                            if colc - glc > 0 {
                                if ((colc - glc) + word.count) <= chessboardColumns {
                                    coordlist.append((colc - glc, rowc, 0, rowc + (colc - glc), 0))
                                }
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
        if c < 1 || r < 1 || c >= chessboardColumns || r >= chessboardColumns {
            return 0
        }
        var count = 1
        var score = 1
        for letter in word {
            let activeCell = getCell(c, row: r)
            if activeCell == chessboardEmptySymbol || activeCell == String(letter) {
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
                if (c >= chessboardColumns || r >= chessboardColumns) {
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
        grid[column - 1, row - 1] = value
    }
    func getCell(_ column: Int, row: Int) -> String{
        return grid[column - 1, row - 1]
    }
    func checkIfCellClear(_ column: Int, row: Int) -> Bool {
        if column > 0 && row > 0 && column < chessboardColumns && row < chessboardColumns {
            return getCell(column, row: row) == chessboardEmptySymbol ? true : false
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
            resultContentArray.append(currentContent!)
            currentWords.append(word)
        }
    }
    // MARK: - Misc
    var isSuccess = false
    @objc func generateSuccess() {
        isSuccess = true
    }
    open var orientationOptimization = false
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
