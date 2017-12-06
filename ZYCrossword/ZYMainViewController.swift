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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        if !isNotShouldReset {
            resetValue(with: self.view.center)
        }
        let imageView = UIImageView()
        imageView.theme_image = "fabImage"
        if (chessboardViewController.promptButton != nil) {
            chessboardViewController.promptButton.image = imageView.image
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.theme_backgroundColor = "loadColor"
        view.addSubview(self.titleViewController.view)
        DispatchQueue(label: "Crosswords").async { [weak self] in
            self?.loadData()
        }
    }
    //MARK: - 加载资源
    func loadData() {
        DispatchQueue.main.sync { [weak self] in
            titleViewController.loadingTitleLabel.text = "正在加载资源包……"
            if self!.initChessboardData() {
                self?.chessboard.printGrid()
                self?.beganChessboard()
            }
        }
    }
    func idString() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyyMMddHmmssS"
        return df.string(from: Date())
    }
    func initChessboardData() -> Bool {
        do {
            let realm = try Realm()
            if let data = NSKeyedUnarchiver.unarchiveObject(withFile: chessboardDocumentPath.getFilePath()) as? ZYChessboard {
                titleViewController.loadingTitleLabel.text = "荷花哈速度会加快……"
                chessboard = data
                tipXdataArr = [ZYBaseWord]()
                for _ in 0 ..< chessboard.tipXArr.count {
                    tipXdataArr.append(ZYBaseWord())
                }
                tipYdataArr = [ZYBaseWord]()
                for _ in 0 ..< chessboard.tipYArr.count {
                    tipYdataArr.append(ZYBaseWord())
                }
                loadChessboardData(realm: realm, type: ZYPoetry.self)
                loadChessboardData(realm: realm, type: ZYMovie.self)
                loadChessboardData(realm: realm, type: ZYBook.self)
                loadChessboardData(realm: realm, type: ZYIdiom.self)
                loadChessboardData(realm: realm, type: ZYAllegoric.self)
                return true
            }else {
                return creatChessboardData()
            }
        }catch {
            return creatChessboardData()
        }
    }
    //MARK: 创建资源
    var chessboard = ZYChessboard()
    var tipXdataArr = [ZYBaseWord]()
    var tipYdataArr = [ZYBaseWord]()
    func creatChessboardData() -> Bool {
        ZYWordViewModel.shareWord.initData()
        guard let _ = UserDefaults.standard.string(forKey: userInfoKey) else {
            ZYUserInforViewModel.shareUserInfor.initData()
            performSegue(withIdentifier: "librarySegueId", sender: self)
            return false
        }
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
            if result.isKind(of: ZYPoetry.self) {
                result.showString = word.word
            }
            try! result.realm?.commitWrite()
            if word.direction == .vertical {
                chessboard.tipYArr.append(word)
                tipYdataArr.append(result)
            }else {
                chessboard.tipXArr.append(word)
                tipXdataArr.append(result)
            }
        }
        NSKeyedArchiver.archiveRootObject(chessboard, toFile: chessboardDocumentPath.getFilePath())
        return true
    }
    //MARK: 加载资源
    func loadChessboardData<T: ZYBaseWord>(realm: Realm, type: T.Type) {
        let showReults = realm.objects(T.self).filter(NSPredicate(format: "isShow = true"))
        for result in showReults {
            for i in 0 ..< chessboard.tipXArr.count {
                if result.showString.contains(chessboard.tipXArr[i].word) {
                    tipXdataArr.remove(at: i)
                    tipXdataArr.insert(result, at: i)
                }
            }
            for i in 0 ..< chessboard.tipYArr.count {
                if result.showString.contains(chessboard.tipYArr[i].word) {
                    tipYdataArr.remove(at: i)
                    tipYdataArr.insert(result, at: i)
                }
            }
        }
    }
    //MARK: 重置资源
    var isNotShouldReset = true
    func resetValue(with point: CGPoint) {
        do{
            try FileManager.default.removeItem(atPath: chessboardDocumentPath.getFilePath())
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
    //MARK: - ViewController
    var titleViewController: ZYTitleViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TitleID") as! ZYTitleViewController
    func beganTitle(with originalPoint: CGPoint) {
        UIView.mdInflateTransition(from: chessboardViewController.view, toView: titleViewController.view, originalPoint: originalPoint, duration: 0.7) {
            self.title = self.titleViewController.title
            DispatchQueue(label: "Crosswords").async { [weak self] in
                self?.loadData()
            }
        }
    }
    var chessboardViewController: ZYChessboardViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChessboardID")  as! ZYChessboardViewController
    func beganChessboard() {
        chessboardViewController.mainViewController = self
        chessboardViewController.chessboard = chessboard
        chessboardViewController.resultXArray = tipXdataArr
        chessboardViewController.resultYArray = tipYdataArr
        UIView.mdInflateTransition(from: titleViewController.view, toView: chessboardViewController.view, originalPoint: titleViewController.loadingActivityIndicator.center, duration: 0.7) {
            self.title = self.chessboardViewController.title
            self.chessboardViewController.creatChessboardViewData()
            self.chessboardViewController.resetValueClosure = { point in
                self.resetValue(with: point)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ZYCrosswordListTableViewController, segue.identifier == "crosswordListSegueId" {
            viewController.loadResult(with: chessboardViewController.resultXArray, YArray: chessboardViewController.resultYArray)
            viewController.tipXArr = chessboard.tipXArr
            viewController.tipYArr = chessboard.tipYArr
            viewController.selectResultBlock = { tag, isPortraitIntro in
                if let button = self.chessboardViewController.chessboardView.viewWithTag(tag) as? ZYChessboardButton {
                    self.chessboardViewController.chessboardView.didSelectedButton = button
                    self.chessboardViewController.chessboardView.isPortraitIntro = isPortraitIntro
                }
            }
        }else if let viewController = segue.destination as? ZYLibraryListViewController, segue.identifier == "librarySegueId" {
            viewController.changeWordBlock = { isChange in
                self.isNotShouldReset = !isChange
            }
        }
    }
}
