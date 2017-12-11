//
//  ZYThemeSelectCollectionViewController.swift
//  ZYCrossword
//
//  Created by 朱勇 on 2017/11/30.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ThemeSelectCellId"
class ZYThemeSelectCollectionViewController: UICollectionViewController {
    var changeThemeBlock:((Bool) -> Void)?
    let themesDataArray = ZYThemes.allValues
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return themesDataArray.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ZYThemeSelectCollectionViewCell
        if indexPath.row < themesDataArray.count {
            cell.titleLabel.text = themesDataArray[indexPath.row].themeTitle
            cell.backgroundColor = UIColor(themesDataArray[indexPath.row].themeColor)
        }
        return cell
    }
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < themesDataArray.count {
            ZYThemes.switchTo(themesDataArray[indexPath.row].themes)
            if self.changeThemeBlock != nil {
                self.changeThemeBlock!(true)
            }
        }
    }
    
}
