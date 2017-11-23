//
//  ZYTitleViewController.swift
//  ZYCrossword
//
//  Created by MAC on 2017/6/12.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit

class ZYTitleViewController: UIViewController {
    var mainViewController: ZYMainViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.theme_backgroundColor = "loadColor"
        loadingActivityIndicator.color = (mainViewController?.navigationController?.navigationBar.barTintColor)!
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
