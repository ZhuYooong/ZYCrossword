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
}
