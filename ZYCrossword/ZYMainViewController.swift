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
        view.addSubview(self.titleViewController.view)
        DispatchQueue(label: "Crosswords").async { [weak self] in
            self?.loadData()
        }
    }
    //MARK: - 加载资源
    func loadData() {
        titleViewController.startLoading()
        titleViewController.loadingTitleLabel.text = "正在加载资源包……"
        initChessboardData()
        chessboard.printGrid()
        beganChessboard()
    }
    func initChessboardData() {
        let realm = try! Realm()
        if let a = realm.objects(ZYChessboard.self).first {
            DispatchQueue.main.sync { [weak self] in
                self?.titleViewController.loadingTitleLabel.text = "荷花哈速度会加快……"
            }
            chessboard = a
            var tipXdataArr = [ZYBaseWord]()
            var tipYdataArr = [ZYBaseWord]()
            let showReults = realm.objects(ZYBaseWord.self).filter(NSPredicate(format: "isShow = true"))
            for result in showReults {
                for Xdata in chessboard.tipXArr {
                    if result.showString.contains(Xdata.word) {
                        tipXdataArr.append(result)
                    }
                }
                for Ydata in chessboard.tipYArr {
                    if result.showString.contains(Ydata.word) {
                        tipYdataArr.append(result)
                    }
                }
            }
            chessboardViewController.resultXArray = tipXdataArr
            chessboardViewController.resultYArray = tipYdataArr
        }else {
            creatChessboardData(with: realm)
        }
    }
    var chessboard = ZYChessboard()
    func creatChessboardData(with realm: Realm) {
        ZYWordViewModel.shareWord.initData()
        let crosswordsGenerator = ZYCrosswordsGenerator()
        DispatchQueue.main.sync { [weak self] in
            self?.titleViewController.loadingTitleLabel.text = "荷花哈速度会加快……"
        }
        crosswordsGenerator.loadCrosswordsData()
        chessboard = ZYChessboard()
        chessboard.grid = crosswordsGenerator.grid
        var tipXdataArr = [ZYBaseWord]()
        var tipYdataArr = [ZYBaseWord]()
        for i in 0 ..< crosswordsGenerator.resultContentArray.count {
            let word = crosswordsGenerator.resultData[i]
            let result = crosswordsGenerator.resultContentArray[i]
            result.isShow = true
            if word.direction == .vertical {
                chessboard.tipYArr.append(word)
                tipYdataArr.append(result)
            }else {
                chessboard.tipXArr.append(word)
                tipXdataArr.append(result)
            }
            try! realm.write {
                realm.add(result, update: true)
            }
        }
        chessboardViewController.resultXArray = tipXdataArr
        chessboardViewController.resultYArray = tipYdataArr
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
