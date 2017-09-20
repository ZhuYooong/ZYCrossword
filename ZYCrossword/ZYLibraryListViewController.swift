//
//  ZYLibraryListViewController.swift
//  ZYCrossword
//
//  Created by MAC on 2017/9/19.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import TisprCardStack
import UIKit

class ZYLibraryListViewController: TisprCardStackViewController, TisprCardStackViewControllerDelegate {
    fileprivate let colors = [UIColor(red: 45.0/255.0, green: 62.0/255.0, blue: 79.0/255.0, alpha: 1.0), UIColor(red: 48.0/255.0, green: 173.0/255.0, blue: 99.0/255.0, alpha: 1.0), UIColor(red: 141.0/255.0, green: 72.0/255.0, blue: 171.0/255.0, alpha: 1.0), UIColor(red: 241.0/255.0, green: 155.0/255.0, blue: 44.0/255.0, alpha: 1.0), UIColor(red: 234.0/255.0, green: 78.0/255.0, blue: 131.0/255.0, alpha: 1.0), UIColor(red: 80.0/255.0, green: 170.0/255.0, blue: 241.0/255.0, alpha: 1.0)]
    fileprivate var countOfCards: Int = 6
    override func viewDidLoad() {
        super.viewDidLoad()
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
    override func numberOfCards() -> Int {
        return countOfCards
    }
    override func card(_ collectionView: UICollectionView, cardForItemAtIndexPath indexPath: IndexPath) -> TisprCardStackViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LibraryCellIdentifier", for: indexPath as IndexPath) as! ZYLibraryListCell
        cell.backgroundColor = .white
        cell.headerView.backgroundColor = colors[indexPath.item % colors.count]
        return cell
    }
    func cardDidChangeState(_ cardIndex: Int) {
        
    }
}
