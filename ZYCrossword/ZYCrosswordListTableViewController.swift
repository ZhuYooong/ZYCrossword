//
//  ZYCrosswordListTableViewController.swift
//  ZYCrossword
//
//  Created by MAC on 2017/7/7.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit

class ZYCrosswordListTableViewController: UITableViewController {
    var selectResultBlock: ((Int, Bool) -> Void)?
    var resultXArray = [ZYBaseWord]()
    var resultYArray = [ZYBaseWord]()
    var tipXArr = Array<Word>()
    var tipYArr = Array<Word>()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    func loadResult(with XArray: [ZYBaseWord], YArray: [ZYBaseWord]) {
        resultXArray = XArray
        resultYArray = YArray
        tableView.reloadData()
    }
    func setCrosswordDataTableViewContentHeight(with index: Int, resultArray: [ZYBaseWord]) -> CGFloat {
        let contentString = setCrosswordDataTableViewContent(with: index, resultArray: resultArray)
        return contentString.textHeightWithFont(UIFont.systemFont(ofSize: 14), constrainedToSize: CGSize(width: tableView.bounds.size.width - 48, height: 10000)) + 28
    }
    func setCrosswordDataTableViewContent(with index: Int, resultArray: [ZYBaseWord]) -> String {
        if index < resultArray.count {
            if let poetryWord = resultArray[index] as? ZYPoetry {
                return poetryWord.showString.showContentString(with: poetryWord.detail, typeString: poetryWord.wordType)
            }else if let movieWord = resultArray[index] as? ZYMovie {
                return movieWord.showString.showContentString(with: movieWord.content_description, typeString: movieWord.wordType)
            }else if let bookWord = resultArray[index] as? ZYBook {
                return bookWord.showString.showContentString(with: bookWord.content_description, typeString: bookWord.wordType)
            }else if let idiomWord = resultArray[index] as? ZYIdiom {
                return idiomWord.showString.showContentString(with: idiomWord.paraphrase ?? "", typeString: idiomWord.wordType)
            }else if let allegoricWord = resultArray[index] as? ZYAllegoric {
                return allegoricWord.showString.showContentString(with: allegoricWord.content ?? "", typeString: allegoricWord.wordType)
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
