//
//  ZYThemes.swift
//  ZYCrossword
//
//  Created by 朱勇 on 2017/11/30.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import SwiftTheme

enum ZYThemes: String {
    case red = "Red"
    case pink = "Pink"
    case purple = "Purple"
    case deepPurple = "Deep Purple"
    case indigo = "Indigo"
    case blue = "Blue"
    case lightBlue = "Light Blue"
    case cyan = "Cyan"
    case teal = "Teal"
    case green = "Green"
    case lightGreen = "Light Geen"
    case orange = "Orange"
    case deepOrange = "Deep Orange"
    case brown = "Brown"
    case blueGrrey = "Blue Grrey"
    
    static var current = ZYThemes.cyan
    static var before  = ZYThemes.cyan
    
    static func switchTo(_ theme: ZYThemes) {
        before  = current
        current = theme
        
        switch theme {
        case .red : ThemeManager.setTheme(plistName: "Red", path: .mainBundle)
        case .pink : ThemeManager.setTheme(plistName: "Pink", path: .mainBundle)
        case .purple : ThemeManager.setTheme(plistName: "Purple", path: .mainBundle)
        case .deepPurple : ThemeManager.setTheme(plistName: "Deep Purple", path: .mainBundle)
        case .indigo : ThemeManager.setTheme(plistName: "Indigo", path: .mainBundle)
        case .blue : ThemeManager.setTheme(plistName: "Blue", path: .mainBundle)
        case .lightBlue : ThemeManager.setTheme(plistName: "Light Blue", path: .mainBundle)
        case .cyan : ThemeManager.setTheme(plistName: "Cyan", path: .mainBundle)
        case .teal : ThemeManager.setTheme(plistName: "Teal", path: .mainBundle)
        case .green : ThemeManager.setTheme(plistName: "Green", path: .mainBundle)
        case .lightGreen : ThemeManager.setTheme(plistName: "Light Geen", path: .mainBundle)
        case .orange : ThemeManager.setTheme(plistName: "Orange", path: .mainBundle)
        case .deepOrange : ThemeManager.setTheme(plistName: "Deep Orange", path: .mainBundle)
        case .brown : ThemeManager.setTheme(plistName: "Brown", path: .mainBundle)
        case .blueGrrey : ThemeManager.setTheme(plistName: "Blue Grrey", path: .mainBundle)
        }
    }
    static let allValues = [ThemeContent(themes: red, themeTitle: "红色", themeColor: 0xE51C23),
                            ThemeContent(themes: pink, themeTitle: "粉红色", themeColor: 0xE91E63),
                            ThemeContent(themes: purple, themeTitle: "紫色", themeColor: 0x9C27B0),
                            ThemeContent(themes: deepPurple, themeTitle: "深紫色", themeColor: 0x673AB7),
                            ThemeContent(themes: indigo, themeTitle: "靛蓝色", themeColor: 0x3F51B5),
                            ThemeContent(themes: blue, themeTitle: "蓝色", themeColor: 0x5677FC),
                            ThemeContent(themes: lightBlue, themeTitle: "淡蓝色", themeColor: 0x03A9F4),
                            ThemeContent(themes: cyan, themeTitle: "蓝绿色", themeColor: 0x00BCD4),
                            ThemeContent(themes: teal, themeTitle: "墨绿色", themeColor: 0x009688),
                            ThemeContent(themes: green, themeTitle: "绿色", themeColor: 0x259B24),
                            ThemeContent(themes: lightGreen, themeTitle: "淡绿色", themeColor: 0x8BC34A),
                            ThemeContent(themes: orange, themeTitle: "橙色", themeColor: 0xFF9800),
                            ThemeContent(themes: deepOrange, themeTitle: "深桔黄色", themeColor: 0xFF5722),
                            ThemeContent(themes: brown, themeTitle: "褐色", themeColor: 0x795548),
                            ThemeContent(themes: blueGrrey, themeTitle: "蓝灰色", themeColor: 0x607D8B)]
}
struct ThemeContent {
    var themes: ZYThemes
    var themeTitle: String
    var themeColor: Int
}
