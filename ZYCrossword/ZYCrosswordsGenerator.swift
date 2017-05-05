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
    // MARK: - Crosswords generation
    var contentArray = [AnyObject]()
    
    func loadData() {
        let allWordArray = ZYWordViewModel.shareWord.loadWordData()
        for word in allWordArray {
            if word.isSelectted == "1" {
                loadJsonData(with: word.wordType)
            }
        }
    }
    func loadJsonData(with name:String?) {
        if name == "" {
            contentArray.append(ZYJsonViewModel.shareJson.loadJsonData(with: ZYTangPoetry300.self))
        }
    }
    open func generate() {
        self.grid = nil
        self.grid = Array2D(columns: columns, rows: rows, defaultValue: emptySymbol)
        
        currentWords.removeAll()
        resultData.removeAll()
        
        
    }
    func findWord(with name: String?) {
        if contentArray.count > 2 {
            let content = contentArray[randomInt(0, max: contentArray.count - 1)]
            var findString: String?
            if let str = name, str.length > 1 {
               let strArray = str.components(separatedBy: "")
               findString = strArray[randomInt(0, max: strArray.count - 1)]
            }
            findWord(with: content, and: findString)
        }
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
