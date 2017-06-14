//
//  ZYMainViewController.swift
//  ZYCrossword
//
//  Created by MAC on 2017/6/9.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import RealmSwift

class ZYMainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleViewController.view)
        performSelector(inBackground: #selector(ZYMainViewController.loadData), with: nil)
    }
    //MARK: - 加载资源
    let realm = try! Realm()
    func loadData() {
        titleViewController.startLoading()
        if let a = realm.objects(ZYChessboard.self).first {
            chessboard = a
        }else {
            chessboard = self.creatChessboardData()
            try! realm.write {
                realm.add(chessboard, update: true)
            }
        }
        chessboard.printGrid()
        beganChessboard()
    }
    var chessboard = ZYChessboard()
    func creatChessboardData() -> ZYChessboard {
        ZYWordViewModel.shareWord.initData()
        let crosswordsGenerator = ZYCrosswordsGenerator()
        crosswordsGenerator.loadCrosswordsData()
        return ZYChessboard(with: crosswordsGenerator)
    }
    //MARK: - ViewController
    var titleViewController: ZYTitleViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TitleID") as! ZYTitleViewController
    func beganTitle(with originalPoint: CGPoint) {
        UIView.mdInflateTransition(from: chessboardViewController.view, toView: titleViewController.view, originalPoint: originalPoint, duration: 0.7) {
            self.loadData()
        }
    }
    var chessboardViewController: ZYChessboardViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChessboardID") as! ZYChessboardViewController
    func beganChessboard() {
        chessboardViewController.chessboard = chessboard
        titleViewController.stopLoading()
        UIView.mdInflateTransition(from: titleViewController.view, toView: chessboardViewController.view, originalPoint: titleViewController.loadingActivityIndicator.center, duration: 0.7) {
            self.chessboardViewController.resetValueClosure = { point in
                self.beganTitle(with: point)
            }
        }
    }
}
