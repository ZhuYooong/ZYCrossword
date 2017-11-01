//
//  ZYCollectListTableViewController.swift
//  ZYCrossword
//
//  Created by MAC on 2017/7/8.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class ZYCollectListTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    private func setup() {
        initData()
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    let realm = try! Realm()
    var collectionDicArray = [[String: Any]]()
    private func initData() {
        if title == "收藏夹" {
            initCollectionData()
        }else {
            initLibraryContentData()
        }
        tableView.reloadData()
    }
    func initCollectionData() {
        appendContent(with: realm.objects(ZYAllegoric.self).filter("isCollect == true"))
        appendContent(with: realm.objects(ZYIdiom.self).filter("isCollect == true"))
        appendContent(with: realm.objects(ZYBook.self).filter("isCollect == true"))
        appendContent(with: realm.objects(ZYMovie.self).filter("isCollect == true"))
        let musicResult = realm.objects(ZYMusic.self).filter("isCollect == true")
        for _ in musicResult { }
        appendContent(with: realm.objects(ZYPoetry.self).filter("isCollect == true"))
        collectionDicArray.sort { (first, second) -> Bool in
            return (first["collectDate"] as? Date ?? Date()) >= (second["collectDate"] as? Date ?? Date())
        }
    }
    func initLibraryContentData() {
        if title == ZYWordType.TangPoetry300.rawValue || title == ZYWordType.SongPoetry300.rawValue || title == ZYWordType.OldPoetry300.rawValue || title == ZYWordType.ShiJing.rawValue || title == ZYWordType.YueFu.rawValue || title == ZYWordType.ChuCi.rawValue || title == ZYWordType.TangPoetryAll.rawValue || title == ZYWordType.SongPoetryAll.rawValue {
            appendContent(with: realm.objects(ZYPoetry.self).filter("wordType = '\(title ?? "")'"))
        }else if title == ZYWordType.Top250Movie.rawValue {
            appendContent(with: realm.objects(ZYMovie.self))
        }else if title == ZYWordType.Top250Book.rawValue {
            appendContent(with: realm.objects(ZYBook.self))
        }else if title == ZYWordType.Idiom.rawValue {
            appendContent(with: realm.objects(ZYIdiom.self))
        }else if title == ZYWordType.Allegoric.rawValue {
            appendContent(with: realm.objects(ZYAllegoric.self))
        }
    }
    func appendContent(with poetryResult: Results<ZYPoetry>) {
        for result in poetryResult {
            collectionDicArray.append(["name": result.title , "type": result.wordType, "collectDate": result.collectDate, "content": poertryContent(with: result.detail), "url": result.url , "firstShort": result.dynasty , "secondShort": result.author, "translate": result.translate , "note": result.note , "appreciation": result.appreciation, "selecttedCount": result.selecttedCount, "height": kCloseCellHeight])
        }
    }
    func appendContent(with movieResult: Results<ZYMovie>) {
        for result in movieResult {
            collectionDicArray.append(["name": result.movie_name , "type": result.wordType, "collectDate": result.collectDate, "content": result.content_description, "url": result.url , "firstShort": result.place , "secondShort": result.direct , "long": result.date, "selecttedCount": result.selecttedCount, "height": kCloseCellHeight])
        }
    }
    func appendContent(with bookResult: Results<ZYBook>) {
        for result in bookResult {
            collectionDicArray.append(["name": result.name , "type": result.wordType, "collectDate": result.collectDate, "content": result.content_description, "url": result.link, "firstShort": result.score , "secondShort": result.author , "long": result.press, "selecttedCount": result.selecttedCount, "height": kCloseCellHeight])
        }
    }
    func appendContent(with idiomResult: Results<ZYIdiom>) {
        for result in idiomResult {
            collectionDicArray.append(["name": result.title ?? "", "type": result.wordType, "collectDate": result.collectDate, "content": result.paraphrase ?? "", "url": idiomUrl(with: result.url ?? "", and: result.wordType, and: result.title ?? ""), "selecttedCount": result.selecttedCount, "height": kCloseCellHeight])
        }
    }
    func appendContent(with allegoricResult: Results<ZYAllegoric>) {
        for result in allegoricResult {
            collectionDicArray.append(["name": result.content ?? "", "content": result.answer ?? "", "url": result.url ?? "", "type": result.wordType, "collectDate": result.collectDate, "selecttedCount": result.selecttedCount, "height": kCloseCellHeight])
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
