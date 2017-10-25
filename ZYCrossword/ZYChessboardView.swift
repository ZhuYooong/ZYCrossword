//
//  ZYChessboardView.swift
//  ZYCrossword
//
//  Created by MAC on 2017/5/25.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit

class ZYChessboardView: UIView {
    open var parientViewController = ZYChessboardViewController()
    //MARK: - button
    var chessboardButtonClosure: ((_ sender: ZYChessboardButton) -> (landscapeIntro: [Array<Int>], portraitIntro: [Array<Int>]))?
    func creatButton(with gridArray: Array2D, resultGrid: Array2D) {
        for button in subviews {
            if button.isKind(of: ZYChessboardButton.self) {
                button.removeFromSuperview()
            }
        }
        for i in 0 ..< chessboardColumns {
            for j in 0 ..< chessboardColumns {
                let str = gridArray[j, i]
                let resultStr = resultGrid[j, i]
                if str != chessboardEmptySymbol {
                    let chessboardButton = ZYChessboardButton(with: str, resultWord: resultStr, column: j, row: i, fatherWidth: self.bounds.size.width)
                    chessboardButton.tag = i * chessboardColumns * 100 + j + 100000
                    self.addSubview(chessboardButton)
                    chessboardButton.addTarget(self, action: #selector(chessboardButtonClick(sender:)), for: .touchUpInside)
                }
            }
        }
        initSelectedView()
    }
    var isPortraitIntro = false {
        didSet {
            if let sender = didSelectedButton {
                chessboardButtonClick(sender: sender)
            }
        }
    }
    var didSelectedButton: ZYChessboardButton?
    @objc func chessboardButtonClick(sender: ZYChessboardButton) {
        didSelectedButton = nil
        let gridArray = chessboardButtonClosure!(sender)
        var toFrame = CGRect()
        for view in subviews {
            if let button = view as? ZYChessboardButton {
                button.selectedState = .normal
            }
        }
        if gridArray.landscapeIntro.count > 0 && !isPortraitIntro {
            toFrame = checkIsGroup(with: gridArray.landscapeIntro)
        }else {
            toFrame = checkIsGroup(with: gridArray.portraitIntro)
            isPortraitIntro = false
        }
        if isFirst {
            changeSelectedView(from: twoSelectedView, to: oneSelectedView, toFrame: toFrame, toPoint: sender.center)
        }else {
            changeSelectedView(from: oneSelectedView, to: twoSelectedView, toFrame: toFrame, toPoint: sender.center)
        }
        sender.selectedState = .selected
        oldGrid = [sender.column, sender.row]
        oldPoint = sender.center
        didSelectedButton = sender
    }
    var oldPoint: CGPoint?
    var oldGrid: Array<Int>?
    func checkIsGroup(with gridArray: [Array<Int>]) -> CGRect {
        var firstOrigin = CGPoint()
        var finalOrigin = CGPoint()
        for i in 0 ..< gridArray.count {
            let grid = gridArray[i]
            if i == 0 {
                firstOrigin = setButtonState(with: grid, selectedState: .call) ?? CGPoint()
            }else if i == gridArray.count - 1 {
                finalOrigin = setButtonState(with: grid, selectedState: .call) ?? CGPoint()
            }else {
                _ = setButtonState(with: grid, selectedState: .call)
            }
        }
        return CGRect(x: firstOrigin.x - 2, y: firstOrigin.y - 2, width: finalOrigin.x - firstOrigin.x + 33, height: finalOrigin.y - firstOrigin.y + 33)
    }
    func setButtonState(with grid: Array<Int>, selectedState: ChessboardButtonSelectedState) -> CGPoint? {
        let tagIndex = grid[1] * chessboardColumns * 100 + grid[0] + 100000
        guard let button = viewWithTag(tagIndex) as? ZYChessboardButton else {
            return nil
        }
        button.selectedState = selectedState
        return button.frame.origin
    }
    //MARK: - view
    var isFirst = true
    let oneSelectedView = UIView()
    let twoSelectedView = UIView()
    func initSelectedView() {
        oneSelectedView.backgroundColor = UIColor(ZYCustomColor.mainBlue.rawValue)
        oneSelectedView.setAmphitheatral(cornerRadius: 4.0)
        twoSelectedView.backgroundColor = UIColor(ZYCustomColor.mainBlue.rawValue)
        twoSelectedView.setAmphitheatral(cornerRadius: 4.0)
    }
    func changeSelectedView(from fromView: UIView, to toView: UIView, toFrame: CGRect, toPoint: CGPoint) {
        toView.frame = toFrame
        insertSubview(toView, at: 0)
        toView.mdInflateAnimated(from: toPoint, backgroundColor: UIColor(ZYCustomColor.buttonSelectedGray.rawValue), duration: 0.3, completion: {
            
        })
        if let grid = oldGrid, let point = oldPoint {
            _ = setButtonState(with: grid, selectedState: .normal)
            fromView.mdDeflateAnimated(to: point, backgroundColor: UIColor(ZYCustomColor.mainBlue.rawValue), duration: 0.3, completion: {
                fromView.removeFromSuperview()
            })
        }
        isFirst = !isFirst
    }
    //MARK: - textInput 
    func textInput(with text: String?) -> Bool {
        var callButtonArray = [ZYChessboardButton]()
        for view in subviews {
            if let button = view as? ZYChessboardButton, button.selectedState == .call || button.selectedState == .selected {
                callButtonArray.append(button)
            }
        }
        if let string = text {
            for button in callButtonArray {
                for word in string.characters {
                    if button.contentState != .right {
                        button.currentWord = String(word)
                        if button.contentState == .right {
                            parientViewController.chessboard.resultGrid[button.column, button.row] = button.currentWord
                            NSKeyedArchiver.archiveRootObject(parientViewController.chessboard, toFile: chessboardDocumentPath.getFilePath())
                            break
                        }
                    }
                }
            }
        }
        for button in callButtonArray {
            if button.contentState != .right {
                return false
            }
        }
        return true
    }
}
