//
//  ZYChessboardViewController.swift
//  ZYCrossword
//
//  Created by MAC on 2017/5/25.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import RealmSwift
import DropDown

class ZYChessboardViewController: UIViewController {
    var mainViewController: ZYMainViewController?
    var chessboard = ZYChessboard()
    var resultXArray = [ZYBaseWord]()
    var resultYArray = [ZYBaseWord]()
    var resetValueClosure: ((_ point: CGPoint) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextfieldNotification()
        creatMoreDropDown()
    }
    //MARK: - Menu
    @IBOutlet weak var starLabel: UILabel!
    @IBAction func starButtonClick(_ sender: UIButton) {
        
    }
    @IBOutlet weak var coinLabel: UILabel!
    @IBAction func coinButtonClick(_ sender: UIButton) {
    }
    @IBAction func resetButtonClick(_ sender: UIButton) {
        let option = UIAlertController(title: nil, message: "您确定要重置本局游戏？", preferredStyle: .alert)
        option.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        option.addAction(UIAlertAction(title: "重置", style: .default) { (action) in
            self.resetValueClosure!(sender.center)
        })
        self.present(option, animated: true, completion: nil)
    }
    @IBAction func bookButtonClick(_ sender: UIButton) {
        mainViewController?.performSegue(withIdentifier: "collectListSegueId", sender: sender)
    }
    @IBOutlet weak var moreButton: UIButton!
    @IBAction func moreButtonClick(_ sender: UIButton) {
        moreDropDown.show()
    }
    let moreDropDown = DropDown()
    func creatMoreDropDown() {
        moreDropDown.anchorView = moreButton
        moreDropDown.bottomOffset = CGPoint(x: -(moreDropDown.bounds.width / 2), y: moreButton.bounds.height / 2)
        moreDropDown.dataSource = [
            "词库",
            "成就",
            "全球排名",
            "购买金币",
            "设置",
            "邀请好友",
            "鼓励评分",
            "关于我们"
        ]
        moreDropDown.selectionAction = { [unowned self] (index, item) in
            if item == "词库" {
                self.mainViewController?.performSegue(withIdentifier: "librarySegueId", sender: self.moreButton)
            }
        }
    }
    //MARK: - ChessboardView
    @IBOutlet weak var chessboardView: ZYChessboardView!
    var landscapeIntro = [Array<Int>]()
    var portraitIntro = [Array<Int>]()
    func creatChessboardViewData() {
        chessboardView.parientViewController = self
        chessboardView.creatButton(with: chessboard.grid, resultGrid: chessboard.resultGrid)
        chessboardView.chessboardButtonClosure = { sender -> (landscapeIntro: [Array<Int>], portraitIntro: [Array<Int>]) in
            var landscapeIntro = [Array<Int>]()
            var portraitIntro = [Array<Int>]()
            var landscapeResultIntro: ZYBaseWord?
            var portraitResultIntro: ZYBaseWord?
            let x = self.setIntro(with: self.chessboard.tipXArr, resultArray: self.resultXArray, sender: sender)
            landscapeResultIntro = x?.resultIntro
            landscapeIntro = x?.intro ?? [Array<Int>]()
            let y = self.setIntro(with: self.chessboard.tipYArr, resultArray: self.resultYArray, sender: sender)
            portraitResultIntro = y?.resultIntro
            portraitIntro = y?.intro ?? [Array<Int>]()
            self.reloadCrosswordData(landscape: landscapeResultIntro, portrait: portraitResultIntro)
            self.landscapeIntro = landscapeIntro
            self.portraitIntro = portraitIntro
            return (landscapeIntro, portraitIntro)
        }
        if let button = chessboardView.viewWithTag(100000) as? ZYChessboardButton {
            chessboardView.chessboardButtonClick(sender: button)
        }
    }
    func setIntro(with tipArray: Array<Word>, resultArray: [ZYBaseWord], sender: ZYChessboardButton) -> (intro: [Array<Int>], resultIntro: ZYBaseWord)? {
        for i in 0 ..< tipArray.count {
            let XWord = tipArray[i]
            for num in XWord.grid {
                if sender.column == num[0] && sender.row == num[1] {
                    return (XWord.grid, resultArray[i])
                }
            }
        }
        return nil
    }
    //MARK: - crosswordDataTableView
    @IBOutlet weak var crosswordDataTableView: UITableView!
    var crosswordDataArray = [ZYBaseWord]()
    var crosswordShowDic = ["landscape":false, "portrait":false]
    func reloadCrosswordData(landscape: ZYBaseWord?, portrait: ZYBaseWord?) {
        crosswordShowDic = ["landscape":false, "portrait":false]
        crosswordDataArray = [ZYBaseWord]()
        if let landscapeWord = landscape {
            crosswordShowDic.updateValue(true, forKey: "landscape")
            crosswordDataArray.append(landscapeWord)
        }
        if let portraitWord = portrait {
            crosswordShowDic.updateValue(true, forKey: "portrait")
            crosswordDataArray.append(portraitWord)
        }
        crosswordDataTableView.reloadData()
    }
    func setCrosswordDataTableViewContentHeight(with index: Int) -> CGFloat {
        let contentString = setCrosswordDataTableViewContent(with: index)
        return contentString.textHeightWithFont(UIFont.systemFont(ofSize: 14), constrainedToSize: CGSize(width: crosswordDataTableView.bounds.size.width - 48, height: 10000)) + 28
    }
    func setCrosswordDataTableViewContent(with index: Int) -> String {
        if index < crosswordDataArray.count {
            if index == 0 {
                if let isLandscape = crosswordShowDic["landscape"], isLandscape == true {
                    return "横向：" + setCrosswordDataTableViewString(with: crosswordDataArray[index])
                }else if let isPortrait = crosswordShowDic["portrait"], isPortrait == true {
                    return "纵向：" + setCrosswordDataTableViewString(with: crosswordDataArray[index])
                }
            }else if index == 1 {
                if let isPortrait = crosswordShowDic["portrait"], isPortrait == true {
                    return "纵向：" + setCrosswordDataTableViewString(with: crosswordDataArray[index])
                }
            }
        }
        return ""
    }
    func setCrosswordDataTableViewString(with word: ZYBaseWord) -> String {
        if let poetryWord = word as? ZYPoetry {
            return poetryWord.showString.showContentString(with: poetryWord.detail, typeString: poetryWord.wordType)
        }else if let movieWord = word as? ZYMovie {
            return movieWord.showString.showContentString(with: movieWord.content_description, typeString: movieWord.wordType)
        }else if let bookWord = word as? ZYBook {
            return bookWord.showString.showContentString(with: bookWord.content_description, typeString: bookWord.wordType)
        }else if let idiomWord = word as? ZYIdiom {
            return idiomWord.showString.showContentString(with: idiomWord.paraphrase ?? "", typeString: idiomWord.wordType)
        }else if let allegoricWord = word as? ZYAllegoric {
            return allegoricWord.showString.showContentString(with: allegoricWord.content ?? "", typeString: allegoricWord.wordType)
        }
        return ""
    }
    func seekHelpButtonClick(sender: UIButton) {
        let baseWord = crosswordDataArray[sender.tag]
    }
    func collectionButtonClick(sender: UIButton) {
        let baseWord = crosswordDataArray[sender.tag]
        if baseWord.isCollect != true {
            baseWord.realm?.beginWrite()
            baseWord.isCollect = true
            baseWord.collectDate = Date()
            try! baseWord.realm?.commitWrite()
            sender.setImage(UIImage(named: "Oval 84"), for: .normal)
        }
    }
    @IBAction func allDataButtonClick(_ sender: UIButton) {
        mainViewController?.performSegue(withIdentifier: "crosswordListSegueId", sender: sender)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    //MARK: - wordInputView
    @IBOutlet weak var wordInputView: UIView!
    @IBOutlet weak var wordInputViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var wordInputTextField: UITextField!
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func setupTextfieldNotification() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(keyWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    func keyWillShow(notification: Notification) -> Void {
        let keyboardF: CGRect = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue)!
        let keyboardT: Double = ((notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]) as? Double)!
        UIView.animate(withDuration: keyboardT) {
            self.wordInputViewBottomConstraint.constant = screenHeight - keyboardF.origin.y
            self.view.layoutIfNeeded()
        }
    }
    func keyWillHide(notification: Notification) -> Void {
        UIView.animate(withDuration: 0.25) {
            self.wordInputViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        wordInputTextField.resignFirstResponder()
    }
    @IBAction func promptButtonClick(_ sender: UIButton) {
        if let baseWord = crosswordDataArray.first, baseWord.isRight == false {
            wordInputTextField.text = baseWord.showString
            _ = textFieldShouldReturn(wordInputTextField)
        }
    }
    @IBAction func sendButtonClick(_ sender: UIButton) {
        _ = textFieldShouldReturn(wordInputTextField)
    }
}
extension ZYChessboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return crosswordDataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CrosswordDataCellID", for: indexPath) as! ZYCrosswordDataTableViewCell
        cell.crosswordDataLabel.text = setCrosswordDataTableViewContent(with: indexPath.row)
        if indexPath.row < crosswordDataArray.count {
            cell.moreFunctionButton.tag = indexPath.row
            let baseWord = crosswordDataArray[indexPath.row]
            if baseWord.isRight == false {
                cell.moreFunctionButton.setImage(UIImage(named: "Oval"), for: .normal)
                cell.moreFunctionButton.addTarget(self, action: #selector(seekHelpButtonClick), for: .touchUpInside)
            }else if baseWord.isCollect == false {
                cell.moreFunctionButton.setImage(UIImage(named: "Oval 85"), for: .normal)
                cell.moreFunctionButton.addTarget(self, action: #selector(collectionButtonClick), for: .touchUpInside)
            }else {
                cell.moreFunctionButton.setImage(UIImage(named: "Oval 84"), for: .normal)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return setCrosswordDataTableViewContentHeight(with: indexPath.row)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            chessboardView.isPortraitIntro = false
        }else if indexPath.row == 1 {
            chessboardView.isPortraitIntro = true
        }
    }
}
extension ZYChessboardViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if chessboardView.textInput(with: textField.text) == true {
            changeWordRight()
            selectedAnotherWord()
        }
        textField.text = ""
        textField.resignFirstResponder()
        return true;
    }
    func changeWordRight() {
        for i in 0 ..< chessboard.tipXArr.count {
            var isRight = true
            for gridIndex in chessboard.tipXArr[i].grid {
                let tagIndex = gridIndex[1] * chessboardColumns * 100 + gridIndex[0] + 100000
                if let button = chessboardView.viewWithTag(tagIndex) as? ZYChessboardButton, button.contentState != .right {
                    isRight = false
                }
            }
            if isRight && resultXArray[i].isRight == false {
                resultXArray[i].realm?.beginWrite()
                resultXArray[i].selecttedCount += 1
                resultXArray[i].isRight = true
                try! resultXArray[i].realm?.commitWrite()
            }
        }
        for i in 0 ..< chessboard.tipYArr.count {
            var isRight = true
            for gridIndex in chessboard.tipYArr[i].grid {
                let tagIndex = gridIndex[1] * chessboardColumns * 100 + gridIndex[0] + 100000
                if let button = chessboardView.viewWithTag(tagIndex) as? ZYChessboardButton, button.contentState != .right {
                    isRight = false
                }
            }
            if isRight && resultYArray[i].isRight == false {
                resultYArray[i].realm?.beginWrite()
                resultYArray[i].selecttedCount += 1
                resultYArray[i].isRight = true
                try! resultYArray[i].realm?.commitWrite()
            }
        }
    }
    func selectedAnotherWord() {
        var selectedWordArray = [Word]()
        for i in 0 ..< resultXArray.count {
            if resultXArray[i].isRight == false {
                selectedWordArray.append(chessboard.tipXArr[i])
            }
        }
        for i in 0 ..< resultYArray.count {
            if resultYArray[i].isRight == false {
                selectedWordArray.append(chessboard.tipYArr[i])
            }
        }
        if selectedWordArray.count > 0 {
            let selectedWord = selectedWordArray[randomInt(selectedWordArray.count)]
            if let selectedGrid = selectedWord.grid.first, selectedGrid.count >= 2 {
                let tagIndex = selectedGrid[1] * chessboardColumns * 100 + selectedGrid[0] + 100000
                if let button = chessboardView.viewWithTag(tagIndex) as? ZYChessboardButton {
                    chessboardView.didSelectedButton = button
                    if chessboard.tipYArr.contains(selectedWord) {
                        chessboardView.isPortraitIntro = true
                    }else {
                        chessboardView.isPortraitIntro = false
                    }
                }
            }
        }else {
            allRight()
        }
    }
    func allRight() {
        let option = UIAlertController(title: "温馨提示", message: "", preferredStyle: .alert)
        option.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        option.addAction(UIAlertAction(title: "分享结果", style: .default) { (action) in
            
        })
        option.addAction(UIAlertAction(title: "请给予评分", style: .default) { (action) in
            
        })
        option.addAction(UIAlertAction(title: "再来一次", style: .default) { (action) in
            self.resetValueClosure!(option.view.center)
        })
        self.present(option, animated: true, completion: nil)
    }
    fileprivate func randomInt(_ max:Int) -> Int {
        return Int(arc4random_uniform(UInt32(max)))
    }
}
