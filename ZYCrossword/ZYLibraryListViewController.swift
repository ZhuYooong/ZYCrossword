//
//  ZYLibraryListViewController.swift
//  ZYCrossword
//
//  Created by MAC on 2017/9/19.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import RealmSwift

class ZYLibraryListViewController: TisprCardStackViewController, TisprCardStackViewControllerDelegate {
    var changeWordBlock:((Bool) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initView()
    }
    //MARK: - 界面和数据
    fileprivate var countOfCards: Int = 3
    var dictionaryWordArray = [ZYWord]()
    var doubanWordArray = [ZYWord]()
    var poetryWordArray = [ZYWord]()
    func initData() {
        let realm = try! Realm()
        let allWordArray = ZYWordViewModel.shareWord.loadWordData(with: realm)
        for word in allWordArray {
            if word.wordType == ZYWordType.TangPoetry300.rawValue {
                poetryWordArray.append(word)
            }else if word.wordType == ZYWordType.SongPoetry300.rawValue {
                poetryWordArray.append(word)
            }else if word.wordType == ZYWordType.OldPoetry300.rawValue {
                poetryWordArray.append(word)
            }else if word.wordType == ZYWordType.ShiJing.rawValue {
                poetryWordArray.append(word)
            }else if word.wordType == ZYWordType.YueFu.rawValue {
                poetryWordArray.append(word)
            }else if word.wordType == ZYWordType.ChuCi.rawValue {
                poetryWordArray.append(word)
            }else if word.wordType == ZYWordType.TangPoetryAll.rawValue {
                poetryWordArray.append(word)
            }else if word.wordType == ZYWordType.SongPoetryAll.rawValue {
                poetryWordArray.append(word)
            }else if word.wordType == ZYWordType.Top250Movie.rawValue {
                doubanWordArray.append(word)
            }else if word.wordType == ZYWordType.Top250Book.rawValue {
                doubanWordArray.append(word)
            }else if word.wordType == ZYWordType.Idiom.rawValue {
                dictionaryWordArray.append(word)
            }else if word.wordType == ZYWordType.Allegoric.rawValue {
                dictionaryWordArray.append(word)
            }
        }
    }
    func initView() {
        let headerView = UIView(frame: CGRect(x: 0, y: -64, width: view.bounds.width, height: 64))
        headerView.backgroundColor = .white
        view.addSubview(headerView)
        //set animation speed
        setAnimationSpeed(0.85)
        
        //set size of cards
        let size = CGSize(width: view.bounds.width - 40, height: 2*view.bounds.height/3)
        setCardSize(size)
        
        cardStackDelegate = self
        
        //configuration of stacks
        layout.topStackMaximumSize = 4
        layout.bottomStackMaximumSize = 30
        layout.bottomStackCardHeight = 45
        
        creatRightLabel()
    }
    //MARK: right item
    //right label
    open var rightCount = 0 {
        didSet {
            rightLabel.text = "已选择 \(rightCount) 本"
        }
    }
    let rightLabel = UILabel()
    func creatRightLabel() {
        rightLabel.textColor = .white
        rightLabel.textAlignment = .right
        rightLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 21)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightLabel)
        
        var count = 0
        for word in dictionaryWordArray {
            if word.isSelectted {
                count += 1
            }
        }
        for word in doubanWordArray {
            if word.isSelectted {
                count += 1
            }
        }
        for word in poetryWordArray {
            if word.isSelectted {
                count += 1
            }
        }
        rightCount = count
    }
    // coin
    open var coinCount = 0 {
        didSet {
            coinButton.setTitle("\(coinCount)", for: .normal)
        }
    }
    let coinButton = UIButton()
    func creatCoinButton() {
        coinButton.setImage(UIImage(named: "金币"), for: .normal)
        coinButton.setTitleColor(.white, for: .normal)
        coinButton.frame = CGRect(x: 0, y: 0, width: 100, height: 21)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: coinButton)
        
        initCoinData()
    }
    func initCoinData() {
        if let user = ZYUserInforViewModel.shareUserInfor.getUserInfo() {
            coinCount = user.coinCount
        }
    }
    func coinButttonClick(sender: UIButton) {
        performSegue(withIdentifier: "libraryToShopSegueId", sender: sender)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ZYCollectListTableViewController, let typeName = sender as? String, segue.identifier == "libraryContentSegueId" {
            viewController.title = typeName
        }
    }
    //MARK: - TisprCardStackViewControllerDelegate
    override func numberOfCards() -> Int {
        return countOfCards
    }
    override func card(_ collectionView: UICollectionView, cardForItemAtIndexPath indexPath: IndexPath) -> TisprCardStackViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LibraryCellIdentifier", for: indexPath as IndexPath) as! ZYLibraryListCell
        cell.backgroundColor = .white
        cell.parientViewController = self
        switch indexPath.item {
        case 0:
            cell.headerView.backgroundColor = UIColor(red: 48.0/255.0, green: 173.0/255.0, blue: 99.0/255.0, alpha: 1.0)
            cell.headerTitleLabel.text = "汉语词典"
            cell.cardContentArray = dictionaryWordArray
        case 1:
            cell.headerView.backgroundColor = UIColor(red: 141.0/255.0, green: 72.0/255.0, blue: 171.0/255.0, alpha: 1.0)
            cell.headerTitleLabel.text = "书影音"
            cell.cardContentArray = doubanWordArray
        case 2:
            cell.headerView.backgroundColor = UIColor(red: 241.0/255.0, green: 155.0/255.0, blue: 44.0/255.0, alpha: 1.0)
            cell.headerTitleLabel.text = "诗词"
            cell.cardContentArray = poetryWordArray
        default:
            break
        }
        cell.cardTableView.reloadData()
        cell.libraryContentBlock = { typeName in
            self.performSegue(withIdentifier: "libraryContentSegueId", sender: typeName)
        }
        cell.changeWordBlock = { isChange in
            if self.changeWordBlock != nil {
                self.changeWordBlock!(true)
                if isChange {
                    self.rightCount += 1
                }else {
                    self.rightCount -= 1
                }
            }
        }
        cell.unlockBlock = { isUnlock in
            if isUnlock {
                self.initCoinData()
            }
        }
        return cell
    }
    func cardDidChangeState(_ cardIndex: Int) {
        
    }
}
