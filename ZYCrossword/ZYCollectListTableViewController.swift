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
    let kCloseCellHeight: CGFloat = 78
    let kDictionaryCellHeight: CGFloat = 163
    let kDoubanCellHeight: CGFloat = 172
    let kPoetryCellHeight: CGFloat = 248
    
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
    var cellContentArray = Array<ZYCollectionInfo>()
    var collectionDicArray = [[String: String]]()
    private func initData() {
        let collectionResult = realm.objects(ZYCollectionInfo.self)
        for result in collectionResult {
            cellContentArray.append(result)
            let collectionWord = result.collectionWord
            if let collectionWord  = collectionWord as? ZYAllegoric {
                detailArray.append(collectionWord.url ?? "")
                collectionDicArray.append(["name": collectionWord.content ?? "", "content": collectionWord.answer ?? "", "type": collectionWord.wordType])
            }else if let collectionWord  = collectionWord as? ZYIdiom {
                detailArray.append(collectionWord.url ?? "")
                collectionDicArray.append(["name": collectionWord.title ?? "", "type": collectionWord.wordType, "content": collectionWord.paraphrase ?? ""])
            }else if let collectionWord  = collectionWord as? ZYBook {
                detailArray.append(collectionWord.link)
                collectionDicArray.append(["name": collectionWord.name , "type": collectionWord.wordType, "content": collectionWord.content_description , "firstShort": collectionWord.score , "secondShort": collectionWord.author , "long": collectionWord.press])
            }else if let collectionWord  = collectionWord as? ZYMovie {
                detailArray.append(collectionWord.url)
                collectionDicArray.append(["name": collectionWord.movie_name , "type": collectionWord.wordType, "content": collectionWord.content_description , "firstShort": collectionWord.place , "secondShort": collectionWord.direct , "long": collectionWord.date])
            }else if let collectionWord  = collectionWord as? ZYMusic {
                
            }else if let collectionWord  = collectionWord as? ZYPoetry {
                detailArray.append(collectionWord.url)
                collectionDicArray.append(["name": collectionWord.title , "type": collectionWord.wordType, "content": collectionWord.detail , "firstShort": collectionWord.dynasty , "secondShort": collectionWord.author, "translate": collectionWord.translate , "note": collectionWord.note , "appreciation": collectionWord.appreciation])
            }
        }
    }
    var detailArray = [String]()
    func detailButtonCliick(sender: UIButton) {
        let webViewController = ZYWebViewController()
        webViewController.httpURL = detailArray[sender.tag]
        webViewController.title = sender.currentTitle
        navigationController?.pushViewController(webViewController, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if case let poetryContentTableViewController as ZYPoetryContentTableViewController = segue.destination, let button = sender as? UIButton, button.tag < collectionDicArray.count  {
            poetryContentTableViewController.contentString = contentString(with: collectionDicArray[button.tag]["content"] ?? "")
            poetryContentTableViewController.title = collectionDicArray[button.tag]["name"] ?? ""
            if segue.identifier == "poetryTranslateSegue" {
                poetryContentTableViewController.titleString = "译文"
                poetryContentTableViewController.explainString = collectionDicArray[button.tag]["translate"] ?? ""
            }else if segue.identifier == "poetryNoteSegue" {
                poetryContentTableViewController.titleString = "注释"
                poetryContentTableViewController.explainString = collectionDicArray[button.tag]["note"] ?? ""
            }else if segue.identifier == "poetryAppreciateSegue" {
                poetryContentTableViewController.titleString = "鉴赏"
                poetryContentTableViewController.explainString = collectionDicArray[button.tag]["appreciation"] ?? ""
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
        if indexPath.row < cellContentArray.count {
            let durations: [TimeInterval] = [0.26, 0.2]
            if let collectionWord = cellContentArray[indexPath.row].collectionWord {
                if collectionWord.isKind(of: ZYAllegoric.self) || collectionWord.isKind(of: ZYIdiom.self) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CollectDictionayCellId", for: indexPath) as! ZYFoldingTableViewCell
                    cell.durationsForExpandedState = durations
                    cell.durationsForCollapsedState = durations
                    return cell
                }else if collectionWord.isKind(of: ZYBook.self) || collectionWord.isKind(of: ZYMovie.self) || collectionWord.isKind(of: ZYMusic.self) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CollectDoubanCellId", for: indexPath) as! ZYFoldingTableViewCell
                    cell.durationsForExpandedState = durations
                    cell.durationsForCollapsedState = durations
                    return cell
                }else if collectionWord.isKind(of: ZYPoetry.self) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CollectPoetryCellId", for: indexPath) as! ZYFoldingTableViewCell
                    cell.durationsForExpandedState = durations
                    cell.durationsForCollapsedState = durations
                    return cell
                }
            }
        }
        return UITableViewCell()
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
