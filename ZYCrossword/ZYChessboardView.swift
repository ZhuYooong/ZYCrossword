//
//  ZYChessboardView.swift
//  ZYCrossword
//
//  Created by MAC on 2017/5/25.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit

class ZYChessboardView: UIView {
    var chessboardButtonClosure: ((_ sender: ZYChessboardButton) -> (landscapeIntro: [Array<Int>], portraitIntro: [Array<Int>]))?
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
        let grid = chessboardButtonClosure!(sender)
        checkIsGroup(with: grid.landscapeIntro)
        checkIsGroup(with: grid.portraitIntro)
        sender.selectedState = .selected
    }
    func checkIsGroup(with gridArray: [Array<Int>]) {
        for grid in gridArray {
            let tagIndex = grid[0] * chessboardColumns + grid[1] + 1000
            guard let button = viewWithTag(tagIndex) as? ZYChessboardButton else {
                return
            }
            button.selectedState = .call
        }
    }
}
