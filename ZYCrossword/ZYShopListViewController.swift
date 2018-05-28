//
//  ZYShopListViewController.swift
//  ZYCrossword
//
//  Created by 朱勇 on 2017/11/2.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import Material
import GoogleMobileAds
import SQLite

class ZYShopListViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SKPaymentQueue.default().add(self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SKPaymentQueue.default().remove(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        NotificationCenter.default.addObserver(self, selector: #selector(initCoinData), name: NSNotification.Name(rawValue: coinCountKey), object: nil)
        createAndLoadVideoAd()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK: - views
    @IBOutlet weak var shopBackgroundScrollView: UIScrollView!
    @IBOutlet weak var shopBackgroundView: UIView!
    @IBOutlet weak var shopViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var shopViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var shopExplainLabel: UILabel!
    func initView() {
        shopViewWidthConstraint.constant = screenWidth
        shopViewHeightConstraint.constant = screenHeight - 128
        shopBackgroundScrollView.contentSize = CGSize(width: screenWidth, height: screenHeight - 128)
        view.layoutIfNeeded()
        
        creatCoinButton()
        shopExplainLabel.text = "1、苹果公司规定，虚拟商品必须使用苹果系统充值购买，充值金额不可自定义，且不能用于安卓、网页等其他平台；\n2、金币充值成功后无法退款、不可提现；\n3、充值任意额度后将免费去除广告。"
        sureButton.theme_backgroundColor = "buttonColor"
    }
    // coin
    open var coinCount = 0 {
        didSet {
            coinButton.setTitle(" \(coinCount)", for: .normal)
        }
    }
    let coinButton = UIButton()
    func creatCoinButton() {
        coinButton.setImage(UIImage(named: "金币"), for: .normal)
        coinButton.setTitleColor(.white, for: .normal)
        coinButton.frame = CGRect(x: 0, y: 0, width: 100, height: 21)
        coinButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: -15)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: coinButton)
        
        initCoinData()
    }
    @objc func initCoinData() {
        if let user = ZYUserInforViewModel.shareUserInfor.getUserInfo() {
            coinCount = user[Expression<Int>("coinCount")]
        }
    }
    //MARK: - button
    @IBOutlet weak var firstShopButton: UIButton!
    @IBAction func firstShopButtonClick(_ sender: UIButton) {//1200
        clickShopButton(with: sender)
        buyCoinCount = 1200
    }
    @IBOutlet weak var secondShopButton: UIButton!
    @IBAction func secondShopButtonClick(_ sender: UIButton) {//4500
        clickShopButton(with: sender)
        buyCoinCount = 4500
    }
    @IBOutlet weak var thirdShopButton: UIButton!
    @IBAction func thirdShopButtonClick(_ sender: UIButton) {//20000
        clickShopButton(with: sender)
        buyCoinCount = 20000
    }
    func clickShopButton(with sender: UIButton) {
        if !sender.isSelected {
            firstShopButton.isSelected = false
            secondShopButton.isSelected = false
            thirdShopButton.isSelected = false
            
            sender.isSelected = true
        }
    }
    @IBAction func advertisementButtonClick(_ sender: UIButton) {
        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }
    }
    @IBOutlet weak var sureButton: RaisedButton!
    @IBAction func sureButtonClick(_ sender: RaisedButton) {
        if buyCoinCount == 1200 || buyCoinCount == 4500 || buyCoinCount == 20000 {
            buyCoin(with: buyCoinCount)
        }else {
            ZYCustomClass.shareCustom.showSnackbar(with: "coin count wrong!", snackbarController: self.snackbarController)
        }
    }
    // MARK: - Buy
    var buyCoinCount = 0
    func buyCoin(with count: Int) {
        if ZYJailbreakDetectTool.share.detectCurrentDeviceIsJailbroken() {
            ZYCustomClass.shareCustom.showSnackbar(with: "当前设备已经越狱，不支持支付操作!", snackbarController: self.snackbarController)
        }else {
            if SKPaymentQueue.canMakePayments() {
                let identifiers: Set<String> = ["\(count)"]
                let request = SKProductsRequest(productIdentifiers: identifiers)
                request.delegate = self
                request.start()
            }
        }
    }
    // TranscationState
    func transcationPurchasing(transcation: SKPaymentTransaction) { // 交易中
        let receiptURL = Bundle.main.appStoreReceiptURL
        do {
            let receipt = try Data(contentsOf: receiptURL!)
        }catch {
            return
        }
        SKPaymentQueue.default().finishTransaction(transcation)
    }
    func transcationPurchased(transcation: SKPaymentTransaction) { // 交易成功
        ZYUserInforViewModel.shareUserInfor.changeCoin(with: buyCoinCount, add: true)
        SKPaymentQueue.default().finishTransaction(transcation)
    }
    func transcationFailed(transcation: SKPaymentTransaction) { // 交易失败
        SKPaymentQueue.default().finishTransaction(transcation)
    }
    func transcationRestored(transcation: SKPaymentTransaction) { // 已经购买过该商品
        SKPaymentQueue.default().finishTransaction(transcation)
    }
    func transcationDeferred(transcation: SKPaymentTransaction) { // 交易延期
        
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    // MARK: - VideoAd
    func createAndLoadVideoAd() {
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
    }
}
extension ZYShopListViewController: GADRewardBasedVideoAdDelegate {
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
        buyCoin(with: 100)
    }
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is closed.")
    }
}
extension ZYShopListViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) { // 查询成功后的回调
        if let product = response.products.first {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
    }
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) { // 购买操作后的回调
        for transcation in transactions {
            switch transcation.transactionState {
            case .deferred:
                transcationDeferred(transcation: transcation)
                break
            case .failed:
                transcationFailed(transcation: transcation)
                break
            case .purchased:
                transcationPurchased(transcation: transcation)
                break
            case .purchasing:
                transcationPurchasing(transcation: transcation)
                break
            case .restored:
                transcationRestored(transcation: transcation)
                break
            }
        }
    }
}
