//
//  ZYChessboardView.swift
//  ZYCrossword
//
//  Created by MAC on 2017/5/25.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit

class ZYChessboardView: UIView {
    var chessboardButtonClosure: ((_ sender: ZYChessboardButton) -> Void)?
    func creatButton(with gridArray: Array2D) {
        for i in 0 ..< chessboardColumns {
            for j in 0 ..< chessboardColumns {
                let str = gridArray[j, i]
                if str != chessboardEmptySymbol {
                    let chessboardButton = ZYChessboardButton(with: str, and: j, and: i, and: self.bounds.size.width)
                    chessboardButton.tag = i * chessboardColumns + j + 1000
                    self.addSubview(chessboardButton)
                    chessboardButton.addTarget(self, action: #selector(chessboardButtonClick(sender:)), for: .touchUpInside)
                }
            }
        }
    }
    func chessboardButtonClick(sender: ZYChessboardButton) {
        chessboardButtonClosure!(sender)
    }
}
