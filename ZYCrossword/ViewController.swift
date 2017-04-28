//
//  ViewController.swift
//  ZYCrossword
//
//  Created by MAC on 2017/4/25.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func loadJson(with name: String) {
        if let path = Bundle.main.path(forResource: name, ofType: "json") {
            if let data = NSData(contentsOfFile: path) as Data? {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String : AnyObject]
                }catch {
                    
                }
            }
        }
    }
}

