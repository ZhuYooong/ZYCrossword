//
//  ZYLibraryListCell.swift
//  ZYCrossword
//
//  Created by MAC on 2017/9/19.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//
import UIKit
import RealmSwift

class ZYLibraryListCell: TisprCardStackViewCell {
    var parientViewController: ZYLibraryListViewController?
    var libraryContentBlock: ((String) -> Void)?
    var changeWordBlock:((Bool) -> Void)?
    let realm = try! Realm()
    
    @IBOutlet weak var backgroundImageiVew: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var cardTableView: UITableView!
    var cardContentArray = [ZYWord]()
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
            if cardContentArray[indexPath.row].isSelectted {
                cell.backgroundImageView.layer.addSublayer(cell.layerRight)
                cell.backgroundImageView.layer.addSublayer(cell.layerLine)
                cell.isCollection = true
            }else {
                cell.layerRight.removeFromSuperlayer()
                cell.layerLine.removeFromSuperlayer()
                cell.isCollection = false
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
            if count <= 2 && cell.isCollection {
                
            }else if count >= 6 && !cell.isCollection {
                
            }else {
                cell.isCollectionSelected = true
                cell.isCollection = !cell.isCollection
                if changeWordBlock != nil {
                    ZYWordViewModel.shareWord.changeWordData(with: cardContentArray[indexPath.row].wordType, and: realm)
                    if cell.isCollection {
                        changeWordBlock!(true)
                    }else {
                        changeWordBlock!(false)
                    }
                }
            }
        }
    }
}