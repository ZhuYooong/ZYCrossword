//
//  ZYLibraryListCell.swift
//  ZYCrossword
//
//  Created by MAC on 2017/9/19.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//
import UIKit
import SQLite

class ZYLibraryListCell: TisprCardStackViewCell {
    var parientViewController: ZYLibraryListViewController?
    var libraryContentBlock: ((String) -> Void)?
    var changeWordBlock:((Bool) -> Void)?
    
    @IBOutlet weak var backgroundImageiVew: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var cardTableView: UITableView!
    var cardContentArray = [ZYDictionary]()
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    func initView() {
        layer.cornerRadius = 8
        clipsToBounds = false
        layer.masksToBounds = true
        headerView.layer.shadowColor = UIColor(ZYCustomColor.textGray.rawValue).cgColor
        headerView.layer.shadowOffset = CGSize(width: 2, height: 5)
        headerView.layer.shadowOpacity = 0.5
        headerView.layer.shadowRadius = 5
        headerView.layer.masksToBounds = true
        backgroundImageiVew.image = backgroundImageiVew.image?.resizableImage(withCapInsets: UIEdgeInsetsMake(20, 10, 20, 10), resizingMode: UIImageResizingMode.stretch)
    }
    override var center: CGPoint {
        didSet {
            updateSmileVote()
        }
    }
    override internal func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        updateSmileVote()
    }
    func updateSmileVote() {
        
    }
    @objc func libraryContentButtonCliick(sender: UIButton) {
        if libraryContentBlock != nil {
            libraryContentBlock!(cardContentArray[sender.tag].wordType)
        }
    }
    func showLockAlert(with wordType: String, index: Int, cell: ZYLabraryCardTableViewCell) {
        if let word = ZYDictionaryViewModel.shareDictionary.loadDictionaryData(with: wordType).first {
            let unlockedCount = UserDefaults.standard.integer(forKey: unlockedKey)
            let truePrice = word[Expression<Int>("price")] + unlockedCount
            let option = UIAlertController(title: "您确定要解锁《\(wordType)》吗？", message: "需要 \(truePrice) 金币", preferredStyle: .alert)
            option.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            option.addAction(UIAlertAction(title: "确定", style: .default) { (action) in
                if truePrice < self.parientViewController!.coinCount {
                    ZYDictionaryViewModel.shareDictionary.changeUnlockedData(with: self.cardContentArray[index].wordType)
                    ZYUserInforViewModel.shareUserInfor.changeCoin(with: truePrice, add: false)
                    self.cardContentArray[index].isUnlocked = true
                    UserDefaults.standard.set(unlockedCount + 1, forKey: unlockedKey)
                    cell.lockImageView.isHidden = true
                }else {
                    ZYCustomClass.shareCustom.showSnackbar(with: "coin count lack!", snackbarController: self.parientViewController?.snackbarController)
                }
            })
            parientViewController?.present(option, animated: true, completion: nil)
        }
    }
}
extension ZYLibraryListCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardContentArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LibraryCardCellId", for: indexPath) as! ZYLabraryCardTableViewCell
        if indexPath.row < cardContentArray.count {
            cell.titleLabel.text = cardContentArray[indexPath.row].wordType
            cell.subTitleLabel.text = "共 \(cardContentArray[indexPath.row].number) 词"
            cell.libraryContentButton.tag = indexPath.row
            cell.libraryContentButton.addTarget(self, action: #selector(libraryContentButtonCliick(sender:)), for: .touchUpInside)
            if cardContentArray[indexPath.row].isUnlocked {
                cell.lockImageView.isHidden = true
                if cardContentArray[indexPath.row].isSelectted {
                    cell.backgroundImageView.layer.addSublayer(cell.layerRight)
                    cell.backgroundImageView.layer.addSublayer(cell.layerLine)
                }else {
                    cell.layerRight.removeFromSuperlayer()
                    cell.layerLine.removeFromSuperlayer()
                }
                cell.isCollection = cardContentArray[indexPath.row].isSelectted
            }else {
                cell.lockImageView.isHidden = false
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let count = parientViewController?.rightCount {
            guard case let cell as ZYLabraryCardTableViewCell = tableView.cellForRow(at: indexPath) else {
                return
            }
            if cardContentArray[indexPath.row].isUnlocked {
                if count <= 2 && cell.isCollection {
                    ZYCustomClass.shareCustom.showSnackbar(with: "less 2!", snackbarController: parientViewController?.snackbarController)
                }else if count >= 6 && !cell.isCollection {
                    ZYCustomClass.shareCustom.showSnackbar(with: "most 6!", snackbarController: parientViewController?.snackbarController)
                }else {
                    cell.isCollectionSelected = true
                    cell.isCollection = !cell.isCollection
                    if changeWordBlock != nil {
                        ZYDictionaryViewModel.shareDictionary.changeSelecttedData(with: cardContentArray[indexPath.row].wordType, selectted: cell.isCollection)
                        cardContentArray[indexPath.row].isSelectted = cell.isCollection
                        changeWordBlock!(true)
                    }
                }
            }else {
                showLockAlert(with: cardContentArray[indexPath.row].wordType, index: indexPath.row, cell: cell)
            }
        }
    }
}
