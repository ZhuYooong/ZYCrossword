//
//  ZYChessboardView.swift
//  ZYCrossword
//
//  Created by MAC on 2017/5/25.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
//public typealias PrefetcherProgressBlock = ((_ skippedResources: [Resource], _ failedResources: [Resource], _ completedResources: [Resource]) -> ())
class ZYChessboardView: UIView {
    func creatButton(with gridArray: Array2D<String>?) {
        for i in 0 ..< chessboardRows {
            for j in 0 ..< chessboardColumns {
                if let str = gridArray?[j, i], str != chessboardEmptySymbol {
                    let chessboardButton = ZYChessboardButton(with: str, and: j, and: i, and: self.bounds.size.width)
                    chessboardButton.tag = i * chessboardRows + j + 1000
                    self.addSubview(chessboardButton)
                    chessboardButton.addTarget(self, action: #selector(chessboardButtonClick(sender:)), for: .touchUpInside)
                }
            }
        }
    }
    func chessboardButtonClick(sender: ZYChessboardButton) {
        
    }
}
