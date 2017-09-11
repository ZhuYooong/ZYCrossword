//
//  ZYCollectionInfo.swift
//  ZYCrossword
//
//  Created by MAC on 2017/9/7.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import Foundation
import RealmSwift
class ZYCollectionInfo: Object {
    dynamic var collectionWord: ZYBaseWord? = ZYBaseWord()
    dynamic var height: CGFloat = 78
}
