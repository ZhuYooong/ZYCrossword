//
//  ZYDictionaryDatabase.swift
//  ZYCrossword
//
//  Created by 朱勇 on 2018/5/11.
//  Copyright © 2018年 ZhuYong. All rights reserved.
//

import Foundation
import SQLite

struct ZYDictionaryDatabase {
    var db: Connection!
    
}
enum ZYDictionaryType: String {
    //诗歌
    case TangPoetry300 = "TangPoetry300"
    case SongPoetry300 = "SongPoetry300"
    case OldPoetry300 = "OldPoetry300"
    case ShiJing = "ShiJing"
    case YueFu = "YueFu"
    case ChuCi = "ChuCi"
    //电影
    case Top250Movie = "Top250Movie"
    //书籍
    case Top250Book = "Top250Book"
    //词典
    case Idiom = "Idiom"
    case Allegoric = "Allegoric"
    static let allValues = [TangPoetry300,SongPoetry300,OldPoetry300,ShiJing,YueFu,ChuCi,
                            Top250Movie,
                            Top250Book,
                            Idiom,Allegoric]
}
