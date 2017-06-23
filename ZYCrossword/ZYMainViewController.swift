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
        do {
            let realm = try Realm()
            if let data = NSKeyedUnarchiver.unarchiveObject(withFile: getFilePath()) as? ZYChessboard {
                DispatchQueue.main.sync { [weak self] in
                    self?.titleViewController.loadingTitleLabel.text = "荷花哈速度会加快……"
                }
                chessboard = data
                var tipXdataArr = [ZYBaseWord]()
                var tipYdataArr = [ZYBaseWord]()
                let PoetryReults = loadChessboardData(realm: realm, type: ZYPoetry.self)
                let MovieReults = loadChessboardData(realm: realm, type: ZYMovie.self)
                let BookReults = loadChessboardData(realm: realm, type: ZYBook.self)
                let IdiomReults = loadChessboardData(realm: realm, type: ZYIdiom.self)
                let AllegoricReults = loadChessboardData(realm: realm, type: ZYAllegoric.self)
                tipXdataArr.append(contentsOf: PoetryReults.tipXdataArr)
                tipXdataArr.append(contentsOf: MovieReults.tipXdataArr)
                tipXdataArr.append(contentsOf: BookReults.tipXdataArr)
                tipXdataArr.append(contentsOf: IdiomReults.tipXdataArr)
                tipXdataArr.append(contentsOf: AllegoricReults.tipXdataArr)
                tipYdataArr.append(contentsOf: PoetryReults.tipYdataArr)
                tipYdataArr.append(contentsOf: MovieReults.tipYdataArr)
                tipYdataArr.append(contentsOf: BookReults.tipYdataArr)
                tipYdataArr.append(contentsOf: IdiomReults.tipYdataArr)
                tipYdataArr.append(contentsOf: AllegoricReults.tipYdataArr)
                chessboardViewController.resultXArray = tipXdataArr
                chessboardViewController.resultYArray = tipYdataArr
            }else {
                creatChessboardData()
            }
        }catch {
            creatChessboardData()
        }
    }
    //MARK: 创建资源
    var chessboard = ZYChessboard()
    func creatChessboardData() {
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
        chessboardViewController.resultXArray = tipXdataArr
        chessboardViewController.resultYArray = tipYdataArr
        NSKeyedArchiver.archiveRootObject(chessboard, toFile: getFilePath())
    }
    let DBFILE_NAME = "Chessboard.plist"
    func getFilePath() -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let DBPath = (documentPath as NSString).appendingPathComponent(DBFILE_NAME)
        return DBPath
    }
    //MARK: 加载资源
    func loadChessboardData<T: ZYBaseWord>(realm: Realm, type: T.Type) -> (tipXdataArr: [ZYBaseWord], tipYdataArr: [ZYBaseWord]) {
        var tipXdataArr = [ZYBaseWord]()
        var tipYdataArr = [ZYBaseWord]()
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
        return (tipXdataArr, tipYdataArr)
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
