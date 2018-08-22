//
//  ZYArray2D.swift
//  ZYCrossword
//
//  Created by MAC on 2017/5/4.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import Foundation
import SQLite

open class Array2D: NSObject, NSCoding {
    open var columns: Int = 0
    open var rows: Int = 0
    open var matrix: [String] = [String]()
    
    convenience init(columns: Int, rows: Int, defaultValue: String) {
        self.init()
        self.columns = columns
        self.rows = rows
        matrix.removeAll()
        matrix = Array(repeating: defaultValue, count: columns * rows)
    }
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(NSNumber(value: self.columns), forKey: "columns")
        aCoder.encode(NSNumber(value: self.rows), forKey: "rows")
        aCoder.encode(self.matrix, forKey: "matrix")
    }
    required public init(coder aDecoder: NSCoder) {
        super.init()
        self.columns = aDecoder.decodeObject(forKey: "columns") as! Int
        self.rows = aDecoder.decodeObject(forKey: "rows") as! Int
        self.matrix = aDecoder.decodeObject(forKey: "matrix") as! [String]
    }
    override init() {
        
    }
    open subscript(column: Int, row: Int) -> String {
        get {
            return matrix[columns * row + column]
        }set {
            matrix[columns * row + column] = newValue
        }
    }
    open func columnCount() -> Int {
        return self.columns
    }
    open func rowCount() -> Int {
        return self.rows
    }
}
extension Array {
    func containsContent<T>(obj: T) -> Bool {
        if let row = obj as? Row {
            return self.filter({ (ele) -> Bool in
                (ele as! Row)[Expression<String>("showString")] == row[Expression<String>("showString")]
            }).count > 0
        }else {
            return self.filter({$0 as? T == obj as! _OptionalNilComparisonType}).count > 0
        }
    }
}
