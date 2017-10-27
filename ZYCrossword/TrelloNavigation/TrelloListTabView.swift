//
//  TrelloListTabView.swift
//  TrelloNavigation
//
//  Created by 宋宋 on 15/11/8.
//  Copyright © 2015年 Qing. All rights reserved.
//

import UIKit

public typealias TrelloTabCells = TrelloCells
public typealias LayoutViews = ([UIView]) -> [UIView]
public typealias ClickIndex = (Int) -> ()

public class TrelloListTabView: UIScrollView {
    public var didClickIndex: ClickIndex?
    public var tabs: [String] = []
    
    public var selectedIndex : Int = 0 {
        didSet {
            TrelloAnimate.tabSelectedAnimate(tabView: self)
        }
    }
    public init(frame: CGRect, trelloTabCells: TrelloTabCells) {
        super.init(frame: frame)
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false

        let layoutViews: LayoutViews = { views in
            var next: CGFloat = 70.0
            var i = 0
            return views.map { view in
                view.left = next
                next += view.width
                view.tag = 100000 + i
                i += 1
                return view
            }
        }
        contentSize = CGSize(width: 70.0 + CGFloat(trelloTabCells().count) * 30.0, height: height)
        addSubviews(views: layoutViews(trelloTabCells()))
        _ = subviews.map { tabCell in
            guard let tabCell = tabCell as? TrelloListTabItemView else { return }
            tabs.append(tabCell.titleLabel.text ?? "")
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapTab(tap:)))
        addGestureRecognizer(tap)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func tapTab(tap: UITapGestureRecognizer) {
        if let didClickIndex = didClickIndex {
            if let tag = pointForSubview(point: tap.location(in: self))?.tag {
                didClickIndex(tag - 100000)
            } else {
                didClickIndex(selectedIndex)
            }
        }
    }
}
