//
//  ZYMainViewController.swift
//  ZYCrossword
//
//  Created by MAC on 2017/6/9.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SQLite

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
        updateVersionOrLoadData()
        interstitial = createAndLoadInterstitial()
    }
    //MARK: - 资源
    var chessboard: ZYChessboard?
    var tipXdataArr = [ZYWord]()
    var tipYdataArr = [ZYWord]()
    //MARK: 加载资源
    func loadData() {
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: chessboardDocumentPath.getFilePath()) as? ZYChessboard {
            loadCurentChessboardData(data: data)
        }else if let data = NSKeyedUnarchiver.unarchiveObject(withFile: ZYCustomClass.shareCustom.anotherChessboardPath(isUpdate: true).getFilePath()) as? ZYChessboard {
            loadCurentChessboardData(data: data)
        }else {
            NotificationCenter.default.addObserver(self, selector: #selector(creatData), name: NSNotification.Name(rawValue: baseWordKey), object: nil)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func loadCurentChessboardData(data: ZYChessboard) {
        titleViewController.loadingTitleLabel.text = "荷花哈速度会加快……"
        let group = DispatchGroup()
        DispatchQueue(label: "loadCurentChessboardData", attributes: .concurrent).async(group: group) {
            self.chessboard = data
            self.tipXdataArr = [ZYWord]()
            for _ in 0 ..< self.chessboard!.tipXArr.count {
                self.tipXdataArr.append(ZYWord())
            }
            self.tipYdataArr = [ZYWord]()
            for _ in 0 ..< self.chessboard!.tipYArr.count {
                self.tipYdataArr.append(ZYWord())
            }
            self.loadChessboardData()
        }
        group.wait()
        beganChessboard()
    }
    func loadChessboardData() {
        let showReults = ZYWordViewModel.shareWord.loadShowData()
        for result in showReults {
            autoreleasepool {
                for i in 0 ..< chessboard!.tipXArr.count {
                    if result[Expression<String>("showString")].contains(chessboard!.tipXArr[i].word) {
                        tipXdataArr.remove(at: i)
                        tipXdataArr.insert(ZYWordViewModel.shareWord.formatConversionWord(with: result), at: i)
                    }
                }
                for i in 0 ..< chessboard!.tipYArr.count {
                    if result[Expression<String>("showString")].contains(chessboard!.tipYArr[i].word) {
                        tipYdataArr.remove(at: i)
                        tipYdataArr.insert(ZYWordViewModel.shareWord.formatConversionWord(with: result), at: i)
                    }
                }
            }
        }
    }
    //MARK: 创建资源
    @objc func creatData() {
        if chessboard == nil {
            if self.creatChessboardData() {
                self.chessboard?.printGrid()
                DispatchQueue.main.sync {
                    self.beganChessboard()
                }
            }
        }
    }
    func creatChessboardData() -> Bool {
        guard let _ = ZYSecretClass.shareSecret.getUserDefaults(with: userInfoKey) else {
            ZYUserInforViewModel.shareUserInfor.initUserInfor()
            isNotShouldReset = false
            performSegue(withIdentifier: "librarySegueId", sender: self)
            return false
        }
        let crosswordsGenerator = ZYCrosswordsGenerator.shareCrosswordsGenerator
        DispatchQueue.main.sync {
            titleViewController.loadingTitleLabel.text = "荷花哈速度会加快……"
        }
        crosswordsGenerator.loadCrosswordsData(isBackgrounding: false)
        chessboard = crosswordsGenerator.chessboard
        tipXdataArr = crosswordsGenerator.tipXdataArr
        tipYdataArr = crosswordsGenerator.tipYdataArr
        return true
    }
    //MARK: 重置资源
    var isNotShouldReset = true
    func resetValue(with point: CGPoint, isShowInterstitial: Bool = false) {
        if isNotShouldReset {
            removeChessboardData(atPath: chessboardDocumentPath)
            if let data = NSKeyedUnarchiver.unarchiveObject(withFile: ZYCustomClass.shareCustom.anotherChessboardPath(isUpdate: true).getFilePath()) as? ZYChessboard {
                self.beganTitle(with: point, isShowInterstitial: isShowInterstitial, data: data)
            }else {
                removeChessboardData(atPath: chessboardDocumentPath)
                self.beganTitle(with: point, isShowInterstitial: isShowInterstitial, data: nil)
            }
        }else {
            removeChessboardData(atPath: "Chessboard.plist")
            removeChessboardData(atPath: "ChessboardReserve.plist")
            ZYSecretClass.shareSecret.creatUserDefaults(with: "Chessboard.plist", defultKey: chessboardKey)
            isNotShouldReset = true
            self.beganTitle(with: point, isShowInterstitial: isShowInterstitial, data: nil)
        }
    }
    func removeChessboardData(atPath pathString: String) {
        do{
            try FileManager.default.removeItem(atPath: pathString.getFilePath())
            for baseWord in self.chessboardViewController.resultXArray {
                ZYWordViewModel.shareWord.documentsDatabase.tableLampUpdateWord(with: .showFinished, word: baseWord, show: baseWord.showString)
            }
            for baseWord in self.chessboardViewController.resultYArray {
                ZYWordViewModel.shareWord.documentsDatabase.tableLampUpdateWord(with: .showFinished, word: baseWord, show: baseWord.showString)
            }
        }catch{
            print("error")
        }
    }
    //MARK: - ViewController
    var titleViewController: ZYTitleViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TitleID") as! ZYTitleViewController
    func beganTitle(with originalPoint: CGPoint, isShowInterstitial: Bool, data: ZYChessboard?) {
        UIView.mdInflateTransition(from: chessboardViewController.view, toView: titleViewController.view, originalPoint: originalPoint, duration: 0.7) {
            self.title = self.titleViewController.title
            self.chessboard = nil
            if let data = data {
                self.loadCurentChessboardData(data: data)
            }else {
                DispatchQueue(label: "CrosswordsAnother", attributes: .concurrent).async { [weak self] in
                    self?.creatData()
                }
            }
            if isShowInterstitial {
                if let _ = self.interstitial?.isReady {
                    self.interstitial?.present(fromRootViewController: self)
                }
            }
        }
    }
    var chessboardViewController: ZYChessboardViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChessboardID")  as! ZYChessboardViewController
    var isChangeTheme = false
    func beganChessboard() {
        chessboardViewController.mainViewController = self
        chessboardViewController.chessboard = chessboard!
        chessboardViewController.resultXArray = tipXdataArr
        chessboardViewController.resultYArray = tipYdataArr
        UIView.mdInflateTransition(from: titleViewController.view, toView: chessboardViewController.view, originalPoint: titleViewController.loadingActivityIndicator.center, duration: 0.7) {
            self.title = self.chessboardViewController.title
            self.chessboardViewController.creatChessboardViewData()
//            self.chessboardViewController.showGuides()
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
    func updateVersionOrLoadData() {
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
