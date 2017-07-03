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
        DispatchQueue.main.sync { [weak self] in
            self?.initChessboardData()
            self?.chessboard.printGrid()
            self?.beganChessboard()
        }
    }
    func idString() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyyMMddHmmssS"
        return df.string(from: Date())
    }
    func initChessboardData() {
        do {
            let realm = try Realm()
            if let data = NSKeyedUnarchiver.unarchiveObject(withFile: getFilePath()) as? ZYChessboard {
                titleViewController.loadingTitleLabel.text = "荷花哈速度会加快……"
                chessboard = data
                tipXdataArr = [ZYBaseWord]()
                tipYdataArr = [ZYBaseWord]()
                loadChessboardData(realm: realm, type: ZYPoetry.self)
                loadChessboardData(realm: realm, type: ZYMovie.self)
                loadChessboardData(realm: realm, type: ZYBook.self)
                loadChessboardData(realm: realm, type: ZYIdiom.self)
                loadChessboardData(realm: realm, type: ZYAllegoric.self)
            }else {
                creatChessboardData()
            }
        }catch {
            creatChessboardData()
        }
    }
    //MARK: 创建资源
    var chessboard = ZYChessboard()
    var tipXdataArr = [ZYBaseWord]()
    var tipYdataArr = [ZYBaseWord]()
    func creatChessboardData() {
        ZYWordViewModel.shareWord.initData()
        let crosswordsGenerator = ZYCrosswordsGenerator()
        titleViewController.loadingTitleLabel.text = "荷花哈速度会加快……"
        crosswordsGenerator.loadCrosswordsData()
        chessboard = ZYChessboard()
        chessboard.grid = crosswordsGenerator.grid
        chessboard.resultGrid = Array2D(columns: chessboardColumns, rows: chessboardColumns, defaultValue: chessboardEmptySymbol)
        tipXdataArr = [ZYBaseWord]()
        tipYdataArr = [ZYBaseWord]()
        for i in 0 ..< crosswordsGenerator.resultContentArray.count {
            let word = crosswordsGenerator.resultData[i]
            let result = crosswordsGenerator.resultContentArray[i]
            result.realm?.beginWrite()
            result.isShow = true
            try! result.realm?.commitWrite()
            if word.direction == .vertical {
                chessboard.tipYArr.append(word)
                tipYdataArr.append(result)
            }else {
                chessboard.tipXArr.append(word)
                tipXdataArr.append(result)
            }
        }
        NSKeyedArchiver.archiveRootObject(chessboard, toFile: getFilePath())
    }
    let DBFILE_NAME = "Chessboard.plist"
    func getFilePath() -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let DBPath = (documentPath as NSString).appendingPathComponent(DBFILE_NAME)
        return DBPath
    }
    //MARK: 加载资源
    func loadChessboardData<T: ZYBaseWord>(realm: Realm, type: T.Type) {
        let showReults = realm.objects(T.self).filter(NSPredicate(format: "isShow = true"))
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
        chessboardViewController.resultXArray = tipXdataArr
        chessboardViewController.resultYArray = tipYdataArr
        titleViewController.stopLoading()
        UIView.mdInflateTransition(from: titleViewController.view, toView: chessboardViewController.view, originalPoint: titleViewController.loadingActivityIndicator.center, duration: 0.7) {
            self.chessboardViewController.creatChessboardViewData()
            self.chessboardViewController.resetValueClosure = { point in
                do{
                    try FileManager.default.removeItem(atPath: self.getFilePath())
                    for baseWord in self.chessboardViewController.resultXArray {
                        baseWord.realm?.beginWrite()
                        baseWord.isRight = false
                        baseWord.isShow = false
                        try baseWord.realm?.commitWrite()
                    }
                    for baseWord in self.chessboardViewController.resultYArray {
                        baseWord.realm?.beginWrite()
                        baseWord.isRight = false
                        baseWord.isShow = false
                        try baseWord.realm?.commitWrite()
                    }
                }catch{
                    print("error")
                }
                self.beganTitle(with: point)
            }
        }
    }
}
