//
//  AppDelegate.swift
//  ZYCrossword
//
//  Created by MAC on 2017/4/25.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import RealmSwift
import Material
import SwiftTheme

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        realmSchemaVersion()
        if let themeName = UserDefaults.standard.string(forKey: themeKey) {
            ThemeManager.setTheme(plistName: themeName, path: .mainBundle)
        }else {
            ThemeManager.setTheme(plistName: "Cyan", path: .mainBundle)
        }
        window = UIWindow(frame: Screen.bounds)
        window!.rootViewController = SnackbarController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainID"))
        let navigationBar = UINavigationBar.appearance()
        navigationBar.theme_barTintColor = "mainColor"
        window!.makeKeyAndVisible()
        return true
    }
    //MARK: Realm 版本控制
    let schemaVersion: UInt64 = 1
    func realmSchemaVersion() {
        let config = Realm.Configuration(
            schemaVersion: schemaVersion,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < self.schemaVersion) { }
        })
        Realm.Configuration.defaultConfiguration = config
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

