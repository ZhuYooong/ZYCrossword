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
    func loadData() {
        titleViewController.startLoading()
        titleViewController.loadingTitleLabel.text = "正在加载资源包……"
        performSelector(onMainThread: #selector(ZYMainViewController.initChessboardData), with: nil, waitUntilDone: true)
//        chessboard.printGrid()
        beganChessboard()
    }
    func initChessboardData() {
        let realm = try! Realm()
        if let a = realm.objects(ZYChessboard.self).first {
            chessboard = a
        }else {
            creatChessboardData(with: realm)
        }
    }
    var chessboard = ZYChessboard()
    func creatChessboardData(with realm: Realm) {
        ZYWordViewModel.shareWord.initData()
        let crosswordsGenerator = ZYCrosswordsGenerator()
        titleViewController.loadingTitleLabel.text = "正在准备小抄……"
        crosswordsGenerator.loadCrosswordsData()
        chessboard = ZYChessboard(with: crosswordsGenerator)
        try! realm.write {
            realm.add(chessboard, update: true)
        }
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
