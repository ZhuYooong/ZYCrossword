//
//  ZYArray2D.swift
//  ZYCrossword
//
//  Created by MAC on 2017/5/4.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import Foundation

open class Array2D<T> {
    open var columns: Int
    open var rows: Int
    open var matrix: [T]
    
    public init(columns: Int, rows: Int, defaultValue: T) {
        self.columns = columns
        self.rows = rows
        matrix = Array(repeating: defaultValue, count: columns * rows)
    }
    open subscript(column: Int, row: Int) -> T {
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
