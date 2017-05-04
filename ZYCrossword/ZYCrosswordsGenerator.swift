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
        
        if let str = "s" {
            let predicate = NSPredicate(format: "detail contains '\(str)'")
            return realm.objects(T.self).filter(predicate).sorted(byProperty: "selecttedCount")
        }else {
            
        }
    }
}
