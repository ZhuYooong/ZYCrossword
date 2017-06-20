//
//  ZYChessboardButton.swift
//  ZYCrossword
//
//  Created by MAC on 2017/5/25.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit

class ZYChessboardButton: UIButton {
    // MARK: - Initialization
    init(with word: String, and column: Int, and row: Int, and fatherWidth: CGFloat) {
        self.word = word
        let interval = (fatherWidth - CGFloat(29 * chessboardColumns)) / CGFloat(chessboardColumns - 1)
        super.init(frame: CGRect(x: CGFloat(column) * (interval + 29), y: CGFloat(row) * (interval + 29), width: 29, height: 29))
        creatTittleLabel()
        setBackgroundImage(UIImage(named: "Rectangle"), for: .normal)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - 界面
    public var word = ""
    public var currentWord = "" {
        didSet {
            if contentState != .right {
                tittleLabel.text = currentWord
                if currentWord == "" {
                    contentState = .none
                }else if currentWord == word {
                    contentState = .right
                }else {
                    contentState = .wrong
                }
            }
        }
    }
    fileprivate let tittleLabel = UILabel()
    fileprivate func creatTittleLabel() {
        tittleLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        tittleLabel.textAlignment = .center
        tittleLabel.font = UIFont.systemFont(ofSize: 20)
        self.addSubview(tittleLabel)
        currentWord = ""
    }
    public var selectedState = ChessboardButtonSelectedState.normal {
        didSet {
            switch selectedState {
            case .normal:
                self.setBackgroundImage(UIImage(named: "Rectangle"), for: .normal)
            case .selected:
                self.setBackgroundImage(UIImage(named: "Rectangle Selected"), for: .normal)
            case .call:
                self.setBackgroundImage(UIImage(named: "Rectangle"), for: .normal)
            }
        }
    }
    public var contentState = ChessboardButtonContentState.none {
        didSet {
            switch contentState {
            case .none:
                tittleLabel.textColor = .white
            case .right:
                tittleLabel.textColor = UIColor(ZYCustomColor.buttonTittleGray.rawValue)
            case .wrong:
                tittleLabel.textColor = UIColor(ZYCustomColor.buttonTittleRed.rawValue)
            }
        }
    }
}
public enum ChessboardButtonSelectedState {
    case normal
    case selected
    case call
}
public enum ChessboardButtonContentState {
    case none
    case right
    case wrong
}
