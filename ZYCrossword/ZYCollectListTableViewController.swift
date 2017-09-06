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
    let kOpenCellHeight: CGFloat = 163
    let kRowsCount = 10
    var cellHeights: [CGFloat] = []
    let dictionaryCellId = "CollectDictionayCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    private func setup() {
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
extension ZYCollectListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as ZYCollectDictionaryTableViewCell = cell else {
            return
        }
        cell.backgroundColor = .clear
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
//        cell.number = indexPath.row
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: dictionaryCellId, for: indexPath) as! ZYFoldingTableViewCell
        let durations: [TimeInterval] = [0.26, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ZYFoldingTableViewCell
        if cell.isAnimating() {
            return
        }
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
}
