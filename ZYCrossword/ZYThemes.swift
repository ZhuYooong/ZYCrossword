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
    static let allValues = [red,pink,purple,deepPurple,indigo,blue,lightBlue,cyan,teal,green,lightGreen,orange,deepOrange,brown,blueGrrey]
}
