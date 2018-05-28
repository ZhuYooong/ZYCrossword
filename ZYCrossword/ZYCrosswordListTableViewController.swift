//
//  ZYCrosswordListTableViewController.swift
//  ZYCrossword
//
//  Created by MAC on 2017/7/7.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SQLite

class ZYCrosswordListTableViewController: UITableViewController {
    var selectResultBlock: ((Int, Bool) -> Void)?
    var resultXArray = [ZYWord]()
    var resultYArray = [ZYWord]()
    var tipXArr = Array<Word>()
    var tipYArr = Array<Word>()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    func loadResult(with XArray: [ZYWord], YArray: [ZYWord]) {
        resultXArray = XArray
        resultYArray = YArray
        tableView.reloadData()
    }
    func setCrosswordDataTableViewContentHeight(with index: Int, resultArray: [ZYWord]) -> CGFloat {
        let contentString = setCrosswordDataTableViewContent(with: index, resultArray: resultArray)
        return contentString.textHeightWithFont(UIFont.systemFont(ofSize: 14), constrainedToSize: CGSize(width: tableView.bounds.size.width - 48, height: 10000)) + 28
    }
    func setCrosswordDataTableViewContent(with index: Int, resultArray: [ZYWord]) -> String {
        if index < resultArray.count {
            if ZYDictionaryType.specificPoetryValues.containsContent(obj: resultArray[index].wordType) {
                return resultArray[index].showString.showContentString(with: resultArray[index].detail, typeString: resultArray[index].wordType)
            }else {
                return resultArray[index].showString.showContentString(with: resultArray[index].content, typeString: resultArray[index].wordType)
            }
        }
        return ""
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
extension ZYCrosswordListTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return resultXArray.count
        case 1:
            return resultYArray.count
        default:
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CrosswordListCellID", for: indexPath) as! ZYCrosswordListTableViewCell
        if indexPath.section == 0 {
            cell.crosswordDataLabel.text = setCrosswordDataTableViewContent(with: indexPath.row, resultArray: resultXArray)
        }else if indexPath.section == 1 {
            cell.crosswordDataLabel.text = setCrosswordDataTableViewContent(with: indexPath.row, resultArray: resultYArray)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return setCrosswordDataTableViewContentHeight(with: indexPath.row, resultArray: resultXArray)
        case 1:
            return setCrosswordDataTableViewContentHeight(with: indexPath.row, resultArray: resultYArray)
        default:
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 74, height: 30))
        label.textColor = UIColor(ZYCustomColor.textBlack.rawValue)
        headerView.addSubview(label)
        if section == 0 {
            label.text = "横向提示"
        }else if section == 1 {
            label.text = "纵向提示"
        }
        let lineView = UIView(frame:  CGRect(x: 84, y: 14.5, width: tableView.bounds.size.width - 100, height: 1))
        lineView.backgroundColor = UIColor(ZYCustomColor.textBlack.rawValue)
        headerView.addSubview(lineView)
        return headerView
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-6938332798224330/9023870805"
        bannerView.delegate = self
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        return bannerView
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let grid = tipXArr[indexPath.row].grid.first {
                let tagIndex = grid[1] * chessboardColumns * 100 + grid[0] + 100000
                selectResultBlock!(tagIndex, false)
            }
        }else if indexPath.section == 1 {
            if let grid = tipYArr[indexPath.row].grid.first {
                let tagIndex = grid[1] * chessboardColumns * 100 + grid[0] + 100000
                selectResultBlock!(tagIndex, true)
            }
        }
        _ = navigationController?.popViewController(animated: true)
    }
}
extension ZYCrosswordListTableViewController: GADBannerViewDelegate {
    
}
