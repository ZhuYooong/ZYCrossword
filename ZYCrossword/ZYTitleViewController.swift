//
//  ZYTitleViewController.swift
//  ZYCrossword
//
//  Created by MAC on 2017/6/12.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit

class ZYTitleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    open func initView() {
        view.theme_backgroundColor = "loadColor"
        let colorView = UIView()
        colorView.theme_backgroundColor = "mainColor"
        loadingActivityIndicator.color = colorView.backgroundColor!
        startLoading()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    //MAK: - ActivityIndicator
    @IBOutlet weak var loadingActivityIndicator: ZYActivityIndicator!
    open func startLoading() {
        loadingActivityIndicator.startAnimating()
    }
    open func stopLoading() {
        loadingActivityIndicator.stopAnimating()
    }
    @IBOutlet weak var loadingTitleLabel: UILabel!
}
