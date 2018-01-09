//
//  ZYVersion.swift
//  ZYCrossword
//
//  Created by 朱勇 on 2018/1/4.
//  Copyright © 2018年 ZhuYong. All rights reserved.
//

import UIKit

class ZYVersion: NSObject {
    static let shareVersion = ZYVersion()
    fileprivate override init() {}
    
    func checkNewVersion(appId: String?, bundelId: String?, newVersionBlock: @escaping ((String, String, String, Bool) -> Void)) {
        let infoDic = Bundle.main.infoDictionary
        var currentVersion = infoDic?["CFBundleShortVersionString"] as! String
        var request: URLRequest?
        if appId != nil {
            request = URLRequest(url: URL(string: "http://itunes.apple.com/cn/lookup?id=\(appId!)")!)
        }else if bundelId != nil {
            request = URLRequest(url: URL(string: "http://itunes.apple.com/lookup?bundleId=\(bundelId!)&country=cn")!)
        }else {
            let currentBundelId = infoDic!["CFBundleIdentifier"]
            request = URLRequest(url: URL(string: "http://itunes.apple.com/lookup?bundleId=\(currentBundelId!)&country=cn")!)
        }
        let task = URLSession.shared.dataTask(with: request!) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    newVersionBlock(currentVersion, "", "", false)
                }
            }
            if let urlContent = data {
                let appInfoDic = try! JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String: Any]
                if let resultCount = appInfoDic?["resultCount"] as? Int, resultCount == 0 {
                    DispatchQueue.main.async {
                        newVersionBlock(currentVersion, "", "", false)
                    }
                }
                let results = appInfoDic?["results"] as? [Any]
                let resultDic = results?.first as? [String: String]
                var appStoreVersion = resultDic?["version"] ?? ""
                currentVersion = currentVersion.replacingOccurrences(of: ".", with: "")
                if currentVersion.lengthOfBytes(using: String.Encoding.utf8) == 2 {
                    currentVersion = currentVersion.appending("0")
                }else if currentVersion.lengthOfBytes(using: String.Encoding.utf8) == 1 {
                    currentVersion = currentVersion.appending("00")
                }
                appStoreVersion = appStoreVersion.replacingOccurrences(of: ".", with: "")
                if appStoreVersion.lengthOfBytes(using: String.Encoding.utf8) == 2 {
                    appStoreVersion = appStoreVersion.appending("0")
                }else if currentVersion.lengthOfBytes(using: String.Encoding.utf8) == 1 {
                    appStoreVersion = appStoreVersion.appending("00")
                }
                if Float(currentVersion) ?? 0 < Float(appStoreVersion) ?? 0 {
                    DispatchQueue.main.async {
                        newVersionBlock(currentVersion, resultDic?["version"] ?? "", resultDic?["trackViewUrl"] ?? "", true)
                    }
                }else {
                    DispatchQueue.main.async {
                        newVersionBlock(currentVersion, resultDic?["version"] ?? "", resultDic?["trackViewUrl"] ?? "", false)
                    }
                }
            }
        }
        task.resume()
    }
}
