//
//  ZYLibraryListViewController.swift
//  ZYCrossword
//
//  Created by MAC on 2017/9/19.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import TisprCardStack
import UIKit
import RealmSwift

class ZYLibraryListViewController: TisprCardStackViewController, TisprCardStackViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
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
    }
    //MARK: - TisprCardStackViewControllerDelegate
    override func numberOfCards() -> Int {
        return countOfCards
    }
    override func card(_ collectionView: UICollectionView, cardForItemAtIndexPath indexPath: IndexPath) -> TisprCardStackViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LibraryCellIdentifier", for: indexPath as IndexPath) as! ZYLibraryListCell
        cell.backgroundColor = .white
        switch indexPath.item {
        case 0:
            cell.headerView.backgroundColor = UIColor(red: 48.0/255.0, green: 173.0/255.0, blue: 99.0/255.0, alpha: 1.0)
            cell.headerTitleLabel.text = "汉语词典"
            cell.cardContentArray = dictionaryWordArray
            cell.cardTableView.reloadData()
        case 1:
            cell.headerView.backgroundColor = UIColor(red: 141.0/255.0, green: 72.0/255.0, blue: 171.0/255.0, alpha: 1.0)
            cell.headerTitleLabel.text = "书影音"
            cell.cardContentArray = doubanWordArray
            cell.cardTableView.reloadData()
        case 2:
            cell.headerView.backgroundColor = UIColor(red: 241.0/255.0, green: 155.0/255.0, blue: 44.0/255.0, alpha: 1.0)
            cell.headerTitleLabel.text = "诗词"
            cell.cardContentArray = poetryWordArray
            cell.cardTableView.reloadData()
        default:
            break
        }
        return cell
    }
    func cardDidChangeState(_ cardIndex: Int) {
        
    }
}
