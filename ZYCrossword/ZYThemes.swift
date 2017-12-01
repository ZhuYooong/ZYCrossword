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
    static let allValues = [ThemeContent(themes: red, themeTitle: "#E51C23", themeColor: ""),ThemeContent(themes: pink, themeTitle: "#E91E63", themeColor: ""),ThemeContent(themes: purple, themeTitle: "#9C27B0", themeColor: ""),ThemeContent(themes: deepPurple, themeTitle: "#673AB7", themeColor: ""),ThemeContent(themes: indigo, themeTitle: "#3F51B5", themeColor: ""),ThemeContent(themes: blue, themeTitle: "#5677FC", themeColor: ""),ThemeContent(themes: lightBlue, themeTitle: "#03A9F4", themeColor: ""),ThemeContent(themes: cyan, themeTitle: "#00BCD4", themeColor: ""),ThemeContent(themes: teal, themeTitle: "#009688", themeColor: ""),ThemeContent(themes: green, themeTitle: "#259B24", themeColor: ""),ThemeContent(themes: lightGreen, themeTitle: "#8BC34A", themeColor: ""),ThemeContent(themes: orange, themeTitle: "#FF9800", themeColor: ""),ThemeContent(themes: deepOrange, themeTitle: "#FF5722", themeColor: ""),ThemeContent(themes: brown, themeTitle: "#795548", themeColor: ""),ThemeContent(themes: blueGrrey, themeTitle: "#607D8B", themeColor: "")]
}
struct ThemeContent {
    var themes: ZYThemes
    var themeTitle: String
    var themeColor: String
}
