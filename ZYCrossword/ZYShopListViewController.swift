//
//  ZYShopListViewController.swift
//  ZYCrossword
//
//  Created by 朱勇 on 2017/11/2.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import Material

class ZYShopListViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
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
    func initCoinData() {
        if let user = ZYUserInforViewModel.shareUserInfor.getUserInfo() {
            coinCount = user.coinCount
        }
    }
    //MARK: - button
    @IBOutlet weak var firstShopButton: UIButton!
    @IBAction func firstShopButtonClick(_ sender: UIButton) {
    }
    @IBOutlet weak var secondShopButton: UIButton!
    @IBAction func secondShopButtonClick(_ sender: UIButton) {
    }
    @IBOutlet weak var thirdShopButton: UIButton!
    @IBAction func thirdShopButtonClick(_ sender: UIButton) {
    }
    
    @IBAction func advertisementButtonClick(_ sender: UIButton) {
    }
    @IBAction func sureButtonClick(_ sender: RaisedButton) {
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
