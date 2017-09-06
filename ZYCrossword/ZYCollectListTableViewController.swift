//
//  ZYCollectListTableViewController.swift
//  ZYCrossword
//
//  Created by MAC on 2017/7/8.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit

class ZYCollectListTableViewController: UITableViewController {
    let kCloseCellHeight: CGFloat = 78
    let kDictionaryCellHeight: CGFloat = 163
    let kDoubanCellHeight: CGFloat = 172
    let kPoetryCellHeight: CGFloat = 248
    var cellContentArray: [CollectionContect] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    private func setup() {
        cellContentArray = [CollectionContect(type: .dictionary),CollectionContect(type: .poetry),CollectionContect(type: .douban),CollectionContect(type: .dictionary),CollectionContect(type: .douban),CollectionContect(type: .poetry),CollectionContect(type: .dictionary),CollectionContect(type: .douban),CollectionContect(type: .poetry),CollectionContect(type: .douban)]
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
extension ZYCollectListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellContentArray.count
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as ZYFoldingTableViewCell = cell else {
            return
        }
        cell.backgroundColor = .clear
        if cellContentArray[indexPath.row].height == kCloseCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
//        cell.number = indexPath.row
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < cellContentArray.count {
            let durations: [TimeInterval] = [0.26, 0.2]
            if cellContentArray[indexPath.row].type == .dictionary {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CollectDictionayCellId", for: indexPath) as! ZYFoldingTableViewCell
                cell.durationsForExpandedState = durations
                cell.durationsForCollapsedState = durations
                return cell
            }else if cellContentArray[indexPath.row].type == .douban {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CollectDoubanCellId", for: indexPath) as! ZYFoldingTableViewCell
                cell.durationsForExpandedState = durations
                cell.durationsForCollapsedState = durations
                return cell
            }else if cellContentArray[indexPath.row].type == .poetry {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CollectPoetryCellId", for: indexPath) as! ZYFoldingTableViewCell
                cell.durationsForExpandedState = durations
                cell.durationsForCollapsedState = durations
                return cell
            }else {
                return UITableViewCell()
            }
        }else {
            return UITableViewCell()
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellContentArray[indexPath.row].height
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ZYFoldingTableViewCell
        if cell.isAnimating() {
            return
        }
        var duration = 0.0
        let cellIsCollapsed = cellContentArray[indexPath.row].height == kCloseCellHeight
        if cellIsCollapsed {
            if cell.isKind(of: ZYCollectDictionaryTableViewCell.self) {
                cellContentArray[indexPath.row].height = kDictionaryCellHeight
            }else if cell.isKind(of: ZYCollectDoubanTableViewCell.self) {
                cellContentArray[indexPath.row].height = kDoubanCellHeight
            }else if cell.isKind(of: ZYCollectPoetryTableViewCell.self) {
                cellContentArray[indexPath.row].height = kPoetryCellHeight
            }else {
                return
            }
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellContentArray[indexPath.row].height = kCloseCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
}
struct CollectionContect {
    var type = CollectionType.dictionary
    var height: CGFloat = 78
    
    init(type:CollectionType) {
        self.type = type
        self.height = 78
    }
}
enum CollectionType {
    case dictionary
    case douban
    case poetry
}
