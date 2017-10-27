//
//  TrelloListTabItemView.swift
//  TrelloNavigation
//
//  Created by 宋宋 on 15/11/10.
//  Copyright © 2015年 Qing. All rights reserved.
//

import UIKit

public class TrelloListTabItemView: UIView {
    public var titleLabel: UILabel
    public var heightLevel: Int
    var boardView: UIView
    
    init( frame: CGRect = CGRect.null, item: TrelloListTabItem) {
        var frame = frame
        if frame.isNull {
            frame = CGRect(x: 0, y: 0, width: 30, height: 30 + item.heightLevel * 20 + 20)
        }
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 10.0)
        titleLabel.text = item.title
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        
        boardView = UIView(frame: CGRect(x: 5, y: 5, width: 20, height: item.heightLevel * 10))
        boardView.layer.masksToBounds = true
        boardView.layer.cornerRadius = 5.0
        boardView.backgroundColor = .white
        boardView.alpha = 0.5
        
        heightLevel = item.heightLevel
        super.init(frame: frame)
        addSubviews(views: titleLabel, boardView)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
