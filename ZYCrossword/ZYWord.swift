//
//  ZYWord.swift
//  ZYCrossword
//
//  Created by MAC on 2017/4/27.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import Foundation

class ZYWord: NSObject {
    var id: Int = 0
    var selecttedCount: Int = 0
    var isCollect: Bool = false
    var collectDate: Int = 0
    var isRight: Bool = false
    var isShow: Bool = false
    
    var showString: String = ""
    var wordType: String = ""
    
    var name: String = "" //Poetry & Idiom: title, Movie: movie_name
    var author: String = "" //Movie: direct
    var detail: String = "" //Allegoric: answer, Idiom: enunciation
    var url: String = "" //Book: link
    var content: String = "" //Poetry: translate, Idiom: paraphrase, Book & Movie: content_description
    var date: String = "" //Poetry: dynasty
    var background: String = "" //Idiom: derivation
    var database: String = "" //Book: ISBN, Movie: IMDb
    var type: String = "" //Poetry: topic
    
    var column0: String = "" //Poetry: note, Book: price, Movie: langrage
    var column1: String = "" //Poetry: appreciation, Book: press, Movie: place
    var column2: String = "" // Book: score
    var column3: String = "" // Book: author_profile
    var column4: String = "" // Book: page
}
