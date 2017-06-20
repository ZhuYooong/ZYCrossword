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
    func idString() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyyMMddHmmssS"
        return df.string(from: Date())
    }
    func initChessboardData() {
        if let dic = NSDictionary(contentsOfFile: getFilePath()) {
            DispatchQueue.main.sync { [weak self] in
                self?.titleViewController.loadingTitleLabel.text = "荷花哈速度会加快……"
            }
            chessboard = ZYChessboard(dictionary: dic)
        }else {
            creatChessboardData()
        }
    }
    var chessboard = ZYChessboard()
    func creatChessboardData() {
        ZYWordViewModel.shareWord.initData()
        let crosswordsGenerator = ZYCrosswordsGenerator()
        DispatchQueue.main.sync { [weak self] in
            self?.titleViewController.loadingTitleLabel.text = "荷花哈速度会加快……"
        }
        crosswordsGenerator.loadCrosswordsData()
        chessboard = ZYChessboard(crosswordsGenerator: crosswordsGenerator)
        chessboard.getDictionary().write(toFile: getFilePath(), atomically: true)
    }
    let DBFILE_NAME = "Savedatas.plist"
    func getFilePath() -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
        let DBPath = (documentPath! as NSString).appendingPathComponent(DBFILE_NAME)
        return DBPath
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
            self.chessboardViewController.creatChessboardViewData()
            self.chessboardViewController.resetValueClosure = { point in
                do{
                    try FileManager.default.removeItem(atPath: self.getFilePath())
                }catch{
                    print("error")
                }
                self.beganTitle(with: point)
            }
        }
    }
}
