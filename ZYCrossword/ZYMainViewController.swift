//
//  ZYMainViewController.swift
//  ZYCrossword
//
//  Created by MAC on 2017/6/9.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class ZYMainViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        if !isNotShouldReset {
            resetValue(with: self.view.center)
        }
        // changeTheme
        if (isChangeTheme && chessboardViewController.crosswordDataTableView != nil) {
            chessboardViewController.tableView(chessboardViewController.crosswordDataTableView, didSelectRowAt: IndexPath(row: 0, section: 0))
            isChangeTheme = false
        }
        if (titleViewController.loadingActivityIndicator != nil) {
            let colorView = UIView()
            colorView.theme_backgroundColor = "mainColor"
            titleViewController.loadingActivityIndicator.color = colorView.backgroundColor!
        }
        if (chessboardViewController.promptButton != nil) {
            let imageView = UIImageView()
            imageView.theme_image = "fabImage"
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
        titleViewController.loadingTitleLabel.text = "正在加载资源包……"
        updateVersion()
    }
    //MARK: - 加载资源
    let realm = try! Realm()
    var chessboard: ZYChessboard?
    var tipXdataArr = [ZYBaseWord]()
    var tipYdataArr = [ZYBaseWord]()
    func loadData() {
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: chessboardDocumentPath.getFilePath()) as? ZYChessboard {
            titleViewController.loadingTitleLabel.text = "荷花哈速度会加快……"
            chessboard = data
            tipXdataArr = [ZYBaseWord]()
            for _ in 0 ..< chessboard!.tipXArr.count {
                tipXdataArr.append(ZYBaseWord())
            }
            tipYdataArr = [ZYBaseWord]()
            for _ in 0 ..< chessboard!.tipYArr.count {
                tipYdataArr.append(ZYBaseWord())
            }
            loadChessboardData(realm: realm, type: ZYPoetry.self)
            loadChessboardData(realm: realm, type: ZYMovie.self)
            loadChessboardData(realm: realm, type: ZYBook.self)
            loadChessboardData(realm: realm, type: ZYIdiom.self)
            loadChessboardData(realm: realm, type: ZYAllegoric.self)
            
            beganChessboard()
        }else {
            NotificationCenter.default.addObserver(self, selector: #selector(creatData), name: NSNotification.Name(rawValue: baseWordKey), object: nil)
        }
    }
    @objc func creatData() {
        if chessboard == nil {
            DispatchQueue.main.async {
                if self.creatChessboardData() {
                    self.chessboard?.printGrid()
                    self.beganChessboard()
                }
            }
        }
    }
    func idString() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyyMMddHmmssS"
        return df.string(from: Date())
    }
    //MARK: 创建资源
    func creatChessboardData() -> Bool {
        guard let _ = ZYSecretClass.shareSecret.getUserDefaults(with: userInfoKey) else {
            ZYUserInforViewModel.shareUserInfor.initData()
            isNotShouldReset = false
            performSegue(withIdentifier: "librarySegueId", sender: self)
            return false
        }
        let crosswordsGenerator = ZYCrosswordsGenerator.shareCrosswordsGenerator
        titleViewController.loadingTitleLabel.text = "荷花哈速度会加快……"
        crosswordsGenerator.loadCrosswordsData()
        chessboard = ZYChessboard()
        chessboard?.grid = crosswordsGenerator.grid!
        chessboard?.resultGrid = Array2D(columns: chessboardColumns, rows: chessboardColumns, defaultValue: chessboardEmptySymbol)
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
                chessboard?.tipYArr.append(word)
                tipYdataArr.append(result)
            }else {
                chessboard?.tipXArr.append(word)
                tipXdataArr.append(result)
            }
        }
        NSKeyedArchiver.archiveRootObject(chessboard ?? ZYChessboard(), toFile: chessboardDocumentPath.getFilePath())
        return true
    }
    //MARK: 加载资源
    func loadChessboardData<T: ZYBaseWord>(realm: Realm, type: T.Type) {
        let showReults = realm.objects(T.self).filter(NSPredicate(format: "isShow = true"))
        for result in showReults {
            for i in 0 ..< chessboard!.tipXArr.count {
                if result.showString.contains(chessboard!.tipXArr[i].word) {
                    tipXdataArr.remove(at: i)
                    tipXdataArr.insert(result, at: i)
                }
            }
            for i in 0 ..< chessboard!.tipYArr.count {
                if result.showString.contains(chessboard!.tipYArr[i].word) {
                    tipYdataArr.remove(at: i)
                    tipYdataArr.insert(result, at: i)
                }
            }
        }
    }
    //MARK: 重置资源
    var isNotShouldReset = true
    func resetValue(with point: CGPoint, isShowInterstitial: Bool = false) {
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
        isNotShouldReset = true
        self.beganTitle(with: point, isShowInterstitial: isShowInterstitial)
    }
    //MARK: - ViewController
    var titleViewController: ZYTitleViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TitleID") as! ZYTitleViewController
    func beganTitle(with originalPoint: CGPoint, isShowInterstitial: Bool) {
        UIView.mdInflateTransition(from: chessboardViewController.view, toView: titleViewController.view, originalPoint: originalPoint, duration: 0.7) {
            self.title = self.titleViewController.title
            self.chessboard = nil
            DispatchQueue(label: "CrosswordsAnother").async { [weak self] in
                self?.creatData()
            }
            if isShowInterstitial {
                self.interstitial = self.createAndLoadInterstitial()
            }
        }
    }
    var chessboardViewController: ZYChessboardViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChessboardID")  as! ZYChessboardViewController
    var isChangeTheme = false
    func beganChessboard() {
        DispatchQueue(label: "LoadOther").async {
            ZYWordViewModel.shareWord.initOtherData()
        }
        
        chessboardViewController.mainViewController = self
        chessboardViewController.chessboard = chessboard!
        chessboardViewController.resultXArray = tipXdataArr
        chessboardViewController.resultYArray = tipYdataArr
        UIView.mdInflateTransition(from: titleViewController.view, toView: chessboardViewController.view, originalPoint: titleViewController.loadingActivityIndicator.center, duration: 0.7) {
            self.title = self.chessboardViewController.title
            self.chessboardViewController.creatChessboardViewData()
            self.chessboardViewController.showGuides()
            self.chessboardViewController.resetValueClosure = { point in
                self.resetValue(with: point, isShowInterstitial: true)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ZYCrosswordListTableViewController, segue.identifier == "crosswordListSegueId" {
            viewController.loadResult(with: chessboardViewController.resultXArray, YArray: chessboardViewController.resultYArray)
            viewController.tipXArr = chessboard!.tipXArr
            viewController.tipYArr = chessboard!.tipYArr
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
        }else if let viewController = segue.destination as? ZYThemeSelectCollectionViewController, segue.identifier == "themeSelectSegueId" {
            viewController.changeThemeBlock = { isChange in
                self.isChangeTheme = isChange
            }
        }
    }
    //MARK: - 检测版本
    func updateVersion() {
        ZYVersion.shareVersion.checkNewVersion(appId: nil, bundelId: nil) { (currentVersion, storeVersion, openUrl, isUpdate) in
            if isUpdate {
                self.showAlertView(title: "温馨提示", subTitle: "检测到新版本\(storeVersion),是否更新？", openUrl: openUrl)
            }else {
                self.loadData()
            }
        }
    }
    func showAlertView(title: String, subTitle: String, openUrl: String) {
        let alertVC = UIAlertController(title: title, message: subTitle, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            self.loadData()
        }
        let sure = UIAlertAction(title: "更新", style: .default) { (action) in
            if let url = URL(string: openUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [String: Any](), completionHandler: { (success) in
                        self.loadData()
                    })
                }else {
                    UIApplication.shared.openURL(url)
                }
            }else {
                ZYCustomClass.shareCustom.showSnackbar(with: "update false!", snackbarController: self.snackbarController)
                self.loadData()
            }
        }
        alertVC.addAction(cancel)
        alertVC.addAction(sure)
        present(alertVC, animated: true) { }
    }
    //MARK: - Interstitial
    var interstitial: GADInterstitial?
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-6938332798224330/6206234808")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        
        return interstitial
    }
}
extension ZYMainViewController: GADInterstitialDelegate {
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        interstitial = createAndLoadInterstitial()
    }
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
}
