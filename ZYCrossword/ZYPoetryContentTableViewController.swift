//
//  ZYPoetryContentTableViewController.swift
//  ZYCrossword
//
//  Created by MAC on 2017/9/8.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit

class ZYPoetryContentTableViewController: UITableViewController {
    var contentString = ""
    var titleString = ""
    var explainString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return contentString.textHeightWithFont(UIFont.systemFont(ofSize: 20), constrainedToSize: CGSize(width: UIScreen.main.bounds.size.width - 50, height: 10000))
        }else if indexPath.section == 1 {
            return explainString.textHeightWithFont(UIFont.systemFont(ofSize: 15), constrainedToSize: CGSize(width: UIScreen.main.bounds.size.width - 50, height: 10000))
        }else {
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 12
        }else if section == 1 {
            return 30
        }else {
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
            headerView.backgroundColor = .white
            let label = UILabel(frame: CGRect(x: 10, y: 0, width: 54, height: 30))
            label.font = UIFont.systemFont(ofSize: 20)
            label.textColor = UIColor(ZYCustomColor.textBlack.rawValue)
            headerView.addSubview(label)
            label.text = titleString
            let lineView = UIView(frame:  CGRect(x: 60, y: 14.5, width: tableView.bounds.size.width - 100, height: 1))
            lineView.backgroundColor = UIColor(ZYCustomColor.textGray.rawValue)
            headerView.addSubview(lineView)
            return headerView
        }else {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 12))
            headerView.backgroundColor = .white
            return headerView
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.selectionStyle = .none
        cell.textLabel?.numberOfLines = 0
        if indexPath.section == 0 {
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
            cell.textLabel?.text = contentString
        }else if indexPath.section == 1 {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell.textLabel?.text = explainString
            cell.textLabel?.textColor = UIColor(ZYCustomColor.textBlack.rawValue)
        }
        return cell
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
