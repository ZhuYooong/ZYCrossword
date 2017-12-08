//
//  ZYSecretClass.swift
//  ZYCrossword
//
//  Created by 朱勇 on 2017/12/8.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import CryptoSwift

let userInfoKey = "userInfoUserDefultKey"
let unlockedKey = "unlockedCountDefultKey"
let themeKey = "themeDefultKey"

class ZYSecretClass: NSObject {
    static let shareSecret = ZYSecretClass()
    fileprivate override init() { }
    
    let aes = try! AES(key: "crossword.com123456", iv: "1234567890123456")
    
    func creatUserDefaults(with string: String, defultKey: String) {
        let encrypted = try! aes.encrypt(string.bytes)
        UserDefaults.standard.set(encrypted, forKey: defultKey)
    }
    func getUserDefaults(with defultKey: String) -> String? {
        if let encrypted = UserDefaults.standard.object(forKey: defultKey) as? [UInt8] {
            let decrypted = try! aes.decrypt(encrypted)
            return "\(String(data: Data(decrypted), encoding: .utf8)!)"
        }else {
            return nil
        }
    }
}
