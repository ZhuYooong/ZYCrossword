//
//  ZYJailbreakDetectTool.swift
//  ZYCrossword
//
//  Created by 朱勇 on 2018/2/13.
//  Copyright © 2018年 ZhuYong. All rights reserved.
//

import UIKit

class ZYJailbreakDetectTool: NSObject {
    static let share = ZYJailbreakDetectTool()
    fileprivate override init() { }
    
    open func detectCurrentDeviceIsJailbroken() -> Bool {
        var result = false
        result = detectJailBreakByJailBreakFileExisted()
        if !result {
            result = detectJailBreakByCydiaPathExisted()
        }
        if !result {
            result = detectJailBreakByAppPathExisted()
        }
        if !result {
            result = detectJailBreakByEnvironmentExisted()
        }
        return result
    }
    // 判定常见的越狱文件
    static let jailbreakToolPathes = ["/Applications/Cydia.app",
                                      "/Library/MobileSubstrate/MobileSubstrate.dylib",
                                      "/bin/bash",
                                      "/usr/sbin/sshd",
                                      "/etc/apt"]
    private func detectJailBreakByJailBreakFileExisted() -> Bool {
        for toolPath in ZYJailbreakDetectTool.jailbreakToolPathes {
            if FileManager.default.fileExists(atPath: toolPath) {
                return true
            }
        }
        return false
    }
    private func detectJailBreakByCydiaPathExisted() -> Bool {// 判断cydia的URL scheme
        if UIApplication.shared.canOpenURL(URL(string: "cydia://")!) {
            return true
        }
        return false
    }
    private func detectJailBreakByAppPathExisted() -> Bool {// 读取系统所有应用的名称
        if FileManager.default.fileExists(atPath: "/User/Applications/") {
            do {
                _ = try FileManager.default.contentsOfDirectory(atPath: "/User/Applications/")
                return true
            }catch { }
        }
        return false
    }
    private func detectJailBreakByEnvironmentExisted() -> Bool {
        if getenv("DYLD_INSERT_LIBRARIES") != nil {
            return true
        }
        return false
    }
}
