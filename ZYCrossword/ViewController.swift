//
//  ViewController.swift
//  ZYCrossword
//
//  Created by MAC on 2017/4/25.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ZYWordViewModel.shareWord.initData()
        let chessboard = creatChessboardData()
        chessboard.printGrid()
    }
    func creatChessboardData() -> ZYChessboard {
        let crosswordsGenerator = ZYCrosswordsGenerator()
        crosswordsGenerator.loadCrosswordsData()
        return ZYChessboard(with: crosswordsGenerator)
    }
}

