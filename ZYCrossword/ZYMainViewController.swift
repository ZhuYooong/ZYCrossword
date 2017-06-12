//
//  ZYMainViewController.swift
//  ZYCrossword
//
//  Created by MAC on 2017/6/9.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit

class ZYMainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        beganTitle(with: CGPoint(x: view.bounds.size.width - 30, y: 20))
    }
    //MARK: - 加载资源
    var chessboard = ZYChessboard()
    func creatChessboardData() -> ZYChessboard {
//        ZYWordViewModel.shareWord.initData()
        let crosswordsGenerator = ZYCrosswordsGenerator()
        crosswordsGenerator.loadCrosswordsData()
        return ZYChessboard(with: crosswordsGenerator)
    }
    //MARK: - ViewController
    var titleViewController: ZYTitleViewController {
        get {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TitleID")
            return viewController as! ZYTitleViewController
        }
    }
    func beganTitle(with originalPoint: CGPoint) {
        UIView.mdInflateTransition(from: chessboardViewController.view, toView: titleViewController.view, originalPoint: originalPoint, duration: 0.7) {
            self.titleViewController.startLoading()
            self.chessboard = self.creatChessboardData()
            self.chessboard.printGrid()
            self.beganChessboard()
        }
    }
    var chessboardViewController: ZYChessboardViewController {
        get {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChessboardID")
            return viewController as! ZYChessboardViewController
        }
    }
    func beganChessboard() {
        
        self.titleViewController.stopLoading()
        UIView.mdInflateTransition(from: titleViewController.view, toView: chessboardViewController.view, originalPoint: titleViewController.loadingActivityIndicator.center, duration: 0.7) { }
    }
}
