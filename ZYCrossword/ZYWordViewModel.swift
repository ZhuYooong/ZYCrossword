//
//  ZYWordViewModel.swift
//  ZYCrossword
//
//  Created by MAC on 2017/4/28.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import Foundation
import SwiftyJSON
import SQLite

class ZYWordViewModel: NSObject {
    static let shareWord = ZYWordViewModel()
    fileprivate override init() { }
    
    let documentsDatabase = ZYWordDatabase(filePath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/ZYBaseWord.sqlite3"))
    fileprivate let bundleDatabase = ZYWordDatabase(filePath: Bundle.main.resourcePath!.appending("/ZYBaseWord.sqlite3"))
    //MARK: - 存储本地数据
    func saveWordData() -> Bool {
        if !FileManager.default.fileExists(atPath: documentsDatabase.path) {
            do {
                try FileManager.default.copyItem(atPath: bundleDatabase.path, toPath: documentsDatabase.path)
                return true
            }catch {
                return false
            }
        }else if (FileManager.default.contentsEqual(atPath: bundleDatabase.path, andPath: documentsDatabase.path)) {
            return true
        }else {
            let group = DispatchGroup()
            DispatchQueue(label: "updateDate", attributes: .concurrent).async(group: group) {
                for wordtype in ZYWordType.allValues {
                    self.updateDate(with: wordtype.rawValue)
                }
            }
            group.wait()
            DispatchQueue.global().async {
                return true
            }
        }
    }
    func updateDate(with wordTitle: String) {
        do {
            let documentsCount = try documentsDatabase.db.scalar(Table(wordTitle).count)
            if documentsCount > 0 {
                print("\(wordTitle) is exists")
            }else {
                creatDataWith(with: wordTitle)
            }
        }catch {
            creatDataWith(with: wordTitle)
        }
    }
    func creatDataWith(with wordTitle: String) {
        do {
            documentsDatabase.tableLampCreate(with: wordTitle)
            for item in try bundleDatabase.db.prepare(Table(wordTitle)) {
                documentsDatabase.tableLampInsertItem(with: wordTitle, item: item)
            }
            print("the end -- \(wordTitle)")
        }catch {
            print("insertion failed: \(error)")
        }
    }
    //MARK: - 读取本地数据
    func loadData(with wordType: String, findString: String?) {
        do {
            if let str = findString {
                let word = try documentsDatabase.db.prepare(Table(wordType).filter(Expression<String>("showString").like("%\(findString)%")).order(Expression<Int64>("selecttedCount")))
            }else {
                let word = try documentsDatabase.db.prepare(Table(wordType).order(Expression<Int64>("selecttedCount")))
            }
        }catch {
            print("insertion failed: \(error)")
        }
    }
}
