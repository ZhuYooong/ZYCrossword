//
//  ZYWordDatabase.swift
//  LoadDataDemo
//
//  Created by 朱勇 on 2018/5/11.
//  Copyright © 2018年 tongbuweiye. All rights reserved.
//

import Foundation
import SQLite

struct ZYWordDatabase {
    var db: Connection!
    var path: String
    init(filePath: String) {
        path = filePath
        connectDatabase()
    }
    // 与数据库建立连接
    mutating func connectDatabase() -> Void {
        do {// 与数据库建立连接
            db = try Connection(path)
        }catch {
            print("与数据库建立连接 失败:/(error)")
        }
    }
    
    let id = Expression<Int64>("id")
    let selecttedCount = Expression<Int64>("selecttedCount")
    let isCollect = Expression<Bool>("isCollect")
    let collectDate = Expression<Int64>("collectDate")
    let isRight = Expression<Bool>("isRight")
    let isShow = Expression<Bool>("isShow")
    
    let showString = Expression<String>("showString")
    let wordType = Expression<String>("wordType")
    
    let name = Expression<String>("name")
    let author = Expression<String>("author")
    let detail = Expression<String>("detail")
    let url = Expression<String>("url")
    let content = Expression<String>("content")
    let date = Expression<String>("date")
    let background = Expression<String>("background")
    let database = Expression<String>("database")
    let type = Expression<String>("type")
    
    let column0 = Expression<String>("column0")
    let column1 = Expression<String>("column1")
    let column2 = Expression<String>("column2")
    let column3 = Expression<String>("column3")
    let column4 = Expression<String>("column4")
    //创建表
    func tableLampCreate(with wordTitle: String) -> Void {
        do {
            try db.run(Table(wordTitle).create(ifNotExists: true, block: { (table) in
                table.column(id, primaryKey: true)
                table.column(selecttedCount)
                table.column(isCollect)
                table.column(collectDate)
                table.column(isRight)
                table.column(isShow)
                
                table.column(showString)
                table.column(wordType)
                
                table.column(name)
                table.column(author)
                table.column(detail)
                table.column(url, unique: true)
                table.column(content)
                table.column(date)
                table.column(background)
                table.column(database)
                table.column(type)
                
                table.column(column0)
                table.column(column1)
                table.column(column2)
                table.column(column3)
                table.column(column4)
            }))
        }catch {
            print("insertion failed: \(error)")
        }
    }
    //插入
    func tableLampInsertItem(with wordTitle: String, item: Row) -> Void {
        do {
            _ = try db.run(Table(wordTitle).insert(selecttedCount <- item[Expression<Int64>("selecttedCount")], isCollect <- item[Expression<Bool>("isCollect")], collectDate <- item[Expression<Int64>("collectDate")], isRight <- item[Expression<Bool>("isRight")], isShow <- item[Expression<Bool>("isShow")], showString <- item[Expression<String>("showString")], wordType <- item[Expression<String>("wordType")], name <- item[Expression<String>("name")], author <- item[Expression<String>("author")], detail <- item[Expression<String>("detail")], url <- item[Expression<String>("url")], content <- item[Expression<String>("content")], date <- item[Expression<String>("date")], background <- item[Expression<String>("background")], database <- item[Expression<String>("database")], type <- item[Expression<String>("type")], column0 <- item[Expression<String>("column0")], column1 <- item[Expression<String>("column1")], column2 <- item[Expression<String>("column2")], column3 <- item[Expression<String>("column3")], column4 <- item[Expression<String>("column4")]))
        }catch {
            print("insertion failed: \(error)")
        }
    }
    //替换
    func tableLampUpdateItem(with type: ZYWordUpdateType, word: Row, show: String?) {
        let alice = Table(ZYWordViewModel.shareWord.updateWordTitle(with: word[Expression<String>("wordType")])).filter(id == word[Expression<Int64>("id")])
        do {
            switch type {
            case .showBegin:
                if let string = show {
                    try db.run(alice.update(isShow <- true, showString <- string))
                }else {
                    try db.run(alice.update(isShow <- true))
                }
            case .showFinished:
                if ZYDictionaryType.poetryValues.containsContent(obj: ZYWordViewModel.shareWord.updateWordTitle(with: word[Expression<String>("wordType")])) {
                    try db.run(alice.update(isShow <- false, isRight <- false, showString <- word[Expression<String>("detail")]))
                }else {
                    try db.run(alice.update(isShow <- false, isRight <- false))
                }
            case .collect:
                try db.run(alice.update(isCollect <- true))
            case .selectted:
                try db.run(alice.update(selecttedCount <- (word[Expression<Int64>("selecttedCount")] + 1), isRight <- true))
            }
        }catch {
            print("insertion failed: \(error)")
        }
    }
}
enum ZYWordUpdateType: Int {
    case showBegin = 0
    case showFinished = 1
    case collect = 2
    case selectted = 3
}
