//
//  ZYCollectListTableViewController.swift
//  ZYCrossword
//
//  Created by MAC on 2017/7/8.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SQLite

class ZYCollectListTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    private func setup() {
        initData()
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        createAndLoadBanner()
    }
    //MARK: - Data
    var collectionDicArray = [[String: Any]]()
    private func initData() {
        if title == "收藏夹" {
            appendContent(with: ZYWordViewModel.shareWord.loadCollectData())
            collectionDicArray.sort { (first, second) -> Bool in
                return (first["collectDate"] as? Date ?? Date()) >= (second["collectDate"] as? Date ?? Date())
            }
        }else if let titieString = title {
            appendContent(with: ZYWordViewModel.shareWord.loadWordData(with: titieString, findString: nil, loadedWordType: .ShowString))
        }
        tableView.reloadData()
    }
    func appendContent(with result: [(Row)]) {
        for row in result {
            if ZYDictionaryType.specificPoetryValues.contains(row[Expression<String>("wordType")]) {
                collectionDicArray.append(["name": row[Expression<String>("name")] , "type": row[Expression<String>("wordType")], "collectDate": row[Expression<Int>("collectDate")], "content": poertryContent(with: row[Expression<String>("detail")]), "url": row[Expression<String>("url")], "firstShort": row[Expression<String>("date")], "secondShort": row[Expression<String>("author")], "translate": row[Expression<String>("content")], "note": row[Expression<String>("column0")], "appreciation": row[Expression<String>("column1")], "selecttedCount": row[Expression<Int>("selecttedCount")], "height": kCloseCellHeight])
            }else if ZYDictionaryType.specificDictionaryValues.contains(row[Expression<String>("wordType")]) {
                collectionDicArray.append(["name": row[Expression<String>("name")], "type": row[Expression<String>("wordType")], "collectDate": row[Expression<Int>("collectDate")], "content": row[Expression<String>("content")], "url": idiomUrl(with: row[Expression<String>("url")], and: row[Expression<String>("wordType")], and: row[Expression<String>("name")]), "selecttedCount": row[Expression<Int>("selecttedCount")], "height": kCloseCellHeight])
            }else if ZYDictionaryType.specificDoubanValues.contains(row[Expression<String>("wordType")]) {
                collectionDicArray.append(["name": row[Expression<String>("name")], "type": row[Expression<String>("wordType")], "collectDate": row[Expression<Int>("collectDate")], "content": row[Expression<String>("content")], "url": row[Expression<String>("url")], "firstShort": row[Expression<String>("date")], "secondShort": row[Expression<String>("author")], "long": row[Expression<String>("column1")], "selecttedCount": row[Expression<Int>("selecttedCount")], "height": kCloseCellHeight])
            }
        }
    }
    func idiomUrl(with url: String, and type: String, and name: String) -> String {
        if type == "汉语成语词典" {
            return "http://www.baike.com/wiki/\(name)"
        }else {
            return url
        }
    }
    func poertryContent(with string: String) -> String {
        var content = ""
        let set = CharacterSet(charactersIn: "。！？；)")
        let detailStrArray = string.components(separatedBy: set)
        for i in 0 ..< detailStrArray.count {
            let str = detailStrArray[i]
            if str == "" || str.contains("(") || i == 0 {
                content += str
            }else {
                content += "\n\(str)"
            }
        }
        return content
    }
    let kCloseCellHeight: CGFloat = 78
    let kDictionaryCellHeight: CGFloat = 144
    let kDoubanCellHeight: CGFloat = 172
    let kPoetryCellHeight: CGFloat = 248
    func height(with content: String, height: CGFloat) -> CGFloat {
        let textHeight = content.textHeightWithFont(UIFont.systemFont(ofSize: 15), constrainedToSize: CGSize(width: UIScreen.main.bounds.size.width - 32, height: 1000))
        return textHeight > 20 ? textHeight +  height - 20 : height
    }
    //MARK: - button
    @objc func detailButtonCliick(sender: UIButton) {
        let webViewController = ZYWebViewController()
        webViewController.httpURL = collectionDicArray[sender.tag]["url"] as? String ?? ""
        webViewController.title = collectionDicArray[sender.tag]["name"] as? String ?? ""
        navigationController?.pushViewController(webViewController, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if case let poetryContentTableViewController as ZYPoetryContentTableViewController = segue.destination, let button = sender as? UIButton, button.tag < collectionDicArray.count  {
            poetryContentTableViewController.contentString = collectionDicArray[button.tag]["content"] as? String ?? ""
            poetryContentTableViewController.title = collectionDicArray[button.tag]["name"] as? String ?? ""
            if segue.identifier == "poetryTranslateSegue" {
                poetryContentTableViewController.titleString = "译文"
                poetryContentTableViewController.explainString = collectionDicArray[button.tag]["translate"] as? String ?? ""
            }else if segue.identifier == "poetryNoteSegue" {
                poetryContentTableViewController.titleString = "注释"
                poetryContentTableViewController.explainString = collectionDicArray[button.tag]["note"] as? String ?? ""
            }else if segue.identifier == "poetryAppreciateSegue" {
                poetryContentTableViewController.titleString = "鉴赏"
                poetryContentTableViewController.explainString = collectionDicArray[button.tag]["appreciation"] as? String ?? ""
            }
        }
    }
    func contentString(with string: String) -> String {
        var content = ""
        let set = CharacterSet(charactersIn: "。！？；)")
        let detailStrArray = string.components(separatedBy: set)
        for str in detailStrArray {
            if str == "" || str.contains("(") {
                content += str
            }else {
                content += "\n\(str)"
            }
        }
        return content
    }
    //MARK: - Banner
    func createAndLoadBanner() {
        let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-6938332798224330/9023870805"
        bannerView.delegate = self
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        self.tableView.tableHeaderView = bannerView
    }
}
extension ZYCollectListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionDicArray.count
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as ZYFoldingTableViewCell = cell else {
            return
        }
        cell.backgroundColor = .clear
        if collectionDicArray[indexPath.row]["height"] as? CGFloat ?? 0 == kCloseCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        }else {
            cell.unfold(true, animated: false, completion: nil)
        }
        if title == "收藏夹" {
            cell.isCollection = true
        }else {
            cell.isCollection = false
        }
        if indexPath.row < collectionDicArray.count {
            if case let cell as ZYCollectDictionaryTableViewCell = cell {
                cell.contentDic = collectionDicArray[indexPath.row]
                cell.detailButton.tag = indexPath.row
                cell.detailButton.addTarget(self, action: #selector(detailButtonCliick(sender:)), for: .touchUpInside)
            }else if case let cell as ZYCollectDoubanTableViewCell = cell {
                cell.contentDic = collectionDicArray[indexPath.row]
                cell.detailButton.tag = indexPath.row
                cell.detailButton.addTarget(self, action: #selector(detailButtonCliick(sender:)), for: .touchUpInside)
            }else if case let cell as ZYCollectPoetryTableViewCell = cell {
                cell.contentDic = collectionDicArray[indexPath.row]
                cell.translateButton.tag = indexPath.row
                cell.noteButton.tag = indexPath.row
                cell.appreciateButton.tag = indexPath.row
                cell.detailButton.tag = indexPath.row
                cell.detailButton.addTarget(self, action: #selector(detailButtonCliick(sender:)), for: .touchUpInside)
            }
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < collectionDicArray.count {
            let durations: [TimeInterval] = [0.26, 0.2]
            if collectionDicArray[indexPath.row].count == 7 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CollectDictionayCellId", for: indexPath) as! ZYFoldingTableViewCell
                cell.durationsForExpandedState = durations
                cell.durationsForCollapsedState = durations
                return cell
            }else if collectionDicArray[indexPath.row].count == 10 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CollectDoubanCellId", for: indexPath) as! ZYFoldingTableViewCell
                cell.durationsForExpandedState = durations
                cell.durationsForCollapsedState = durations
                return cell
            }else if collectionDicArray[indexPath.row].count == 12 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CollectPoetryCellId", for: indexPath) as! ZYFoldingTableViewCell
                cell.durationsForExpandedState = durations
                cell.durationsForCollapsedState = durations
                return cell
            }
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (collectionDicArray[indexPath.row]["height"] as? CGFloat) ?? 0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ZYFoldingTableViewCell
        if cell.isAnimating() {
            return
        }
        var duration = 0.0
        let cellIsCollapsed = collectionDicArray[indexPath.row]["height"] as? CGFloat ?? 0 == kCloseCellHeight
        if cellIsCollapsed {
            if case let cell as ZYCollectDictionaryTableViewCell = cell {
                let paperHeight = height(with: collectionDicArray[indexPath.row]["content"] as? String ?? "", height: kDictionaryCellHeight)
                collectionDicArray[indexPath.row]["height"] = paperHeight
                cell.containerViewHeightConstraints.constant = paperHeight - 12 > 132 ? paperHeight - 12 : 132
                cell.containerView.layoutIfNeeded()
            }else if case let cell as ZYCollectDoubanTableViewCell = cell {
                let paperHeight = height(with: collectionDicArray[indexPath.row]["content"] as? String ?? "", height: kDoubanCellHeight)
                collectionDicArray[indexPath.row]["height"] = paperHeight
                cell.containerViewHeightConstraints.constant = paperHeight - 12 > 160 ? paperHeight - 12 : 160
                cell.containerView.layoutIfNeeded()
            }else if case let cell as ZYCollectPoetryTableViewCell = cell {
                let paperHeight = height(with: collectionDicArray[indexPath.row]["content"] as? String ?? "", height: kPoetryCellHeight)
                collectionDicArray[indexPath.row]["height"] = paperHeight
                cell.containerViewHeightConstraints.constant = paperHeight - 12 > 236 ? paperHeight - 12 : 236
                cell.containerView.layoutIfNeeded()
            }else {
                return
            }
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        }else {
            collectionDicArray[indexPath.row]["height"] = kCloseCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
}
extension ZYCollectListTableViewController: GADBannerViewDelegate {
    
}
