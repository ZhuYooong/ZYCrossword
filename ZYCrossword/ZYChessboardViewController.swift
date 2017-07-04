//
//  ZYChessboardViewController.swift
//  ZYCrossword
//
//  Created by MAC on 2017/5/25.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit
import RealmSwift

class ZYChessboardViewController: UIViewController {
    var chessboard: ZYChessboard?
    var resultXArray = [ZYBaseWord]()
    var resultYArray = [ZYBaseWord]()
    var resetValueClosure: ((_ point: CGPoint) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextfieldNotification()
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
    }
    @IBAction func moreButtonClick(_ sender: UIButton) {
    }
    //MARK: - ChessboardView
    @IBOutlet weak var chessboardView: ZYChessboardView!
    func creatChessboardViewData() {
        if let gridArray = chessboard?.grid, let resultGridArray = chessboard?.resultGrid {
            chessboardView.creatButton(with: gridArray, resultGrid: resultGridArray)
            chessboardView.chessboardButtonClosure = { sender -> (landscapeIntro: [Array<Int>], portraitIntro: [Array<Int>]) in
                var landscapeIntro = [Array<Int>]()
                var portraitIntro = [Array<Int>]()
                var landscapeResultIntro: ZYBaseWord?
                var portraitResultIntro: ZYBaseWord?
                let x = self.setIntro(with: self.chessboard!.tipXArr, resultArray: self.resultXArray, sender: sender)
                landscapeResultIntro = x?.resultIntro
                landscapeIntro = x?.intro ?? [Array<Int>]()
                let y = self.setIntro(with: self.chessboard!.tipYArr, resultArray: self.resultYArray, sender: sender)
                portraitResultIntro = y?.resultIntro
                portraitIntro = y?.intro ?? [Array<Int>]()
                self.reloadCrosswordData(landscape: landscapeResultIntro, portrait: portraitResultIntro)
                return (landscapeIntro, portraitIntro)
            }
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
        return contentString.textHeightWithFont(UIFont.systemFont(ofSize: 14), constrainedToSize: CGSize(width: crosswordDataTableView.bounds.size.width - 48, height: 1000)) + 28
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
            return crosswordDataString(with: poetryWord.detail, showString: poetryWord.showString, typeString: poetryWord.wordType)
        }else if let movieWord = word as? ZYMovie {
            return crosswordDataString(with: movieWord.content_description, showString: movieWord.showString, typeString: movieWord.wordType)
        }else if let bookWord = word as? ZYBook {
            return crosswordDataString(with: bookWord.content_description, showString: bookWord.showString, typeString: bookWord.wordType)
        }else if let idiomWord = word as? ZYIdiom {
            return crosswordDataString(with: idiomWord.paraphrase ?? "", showString: idiomWord.showString, typeString: idiomWord.wordType)
        }else if let allegoricWord = word as? ZYAllegoric {
            return crosswordDataString(with: allegoricWord.content ?? "", showString: allegoricWord.showString, typeString: allegoricWord.wordType)
        }
        return ""
    }
    func crosswordDataString(with contentString: String, showString: String, typeString: String) -> String {
        var replaceString = ""
        for _ in 0 ..< showString.characters.count {
            replaceString += "_"
        }
        return contentString.replacingOccurrences(of: showString, with: replaceString) + "\n----" + typeString
    }
    func seekHelpButtonClick(sender: UIButton) {
        let baseWord = crosswordDataArray[sender.tag]
    }
    func collectionButtonClick(sender: UIButton) {
        let baseWord = crosswordDataArray[sender.tag]
        baseWord.realm?.beginWrite()
        baseWord.isCollect = true
        try! baseWord.realm?.commitWrite()
        sender.setImage(UIImage(named: "Oval 84"), for: .normal)
        sender.isUserInteractionEnabled = false
    }
    @IBAction func allDataButtonClick(_ sender: UIButton) {
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
    }
    @IBAction func sendButtonClick(_ sender: UIButton) {
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
}
extension ZYChessboardViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if chessboardView.textInput(with: textField.text) == true {
            changeWordRight()
            selectedAnotherWord()
        }
        textField.resignFirstResponder()
        return true;
    }
    func changeWordRight() {
        if let isLandscape = crosswordShowDic["landscape"], isLandscape == true {
            for i in 0 ..< resultXArray.count {
                if resultXArray[i] == crosswordDataArray[0] {
                    resultXArray[i].realm?.beginWrite()
                    resultXArray[i].selecttedCount += 1
                    resultXArray[i].isRight = true
                    try! resultXArray[i].realm?.commitWrite()
                }
            }
        }else if let isPortrait = crosswordShowDic["portrait"], isPortrait == true {
            for i in 0 ..< resultYArray.count {
                if resultYArray[i] == crosswordDataArray[0] {
                    resultYArray[i].realm?.beginWrite()
                    resultYArray[i].selecttedCount += 1
                    resultYArray[i].isRight = true
                    try! resultYArray[i].realm?.commitWrite()
                }
            }
        }
    }
    func selectedAnotherWord() {
        var selectedWordArray = [Word]()
        for i in 0 ..< resultXArray.count {
            if let word = chessboard?.tipXArr[i], resultXArray[i].isRight == false {
                selectedWordArray.append(word)
            }
        }
        for i in 0 ..< resultYArray.count {
            if let word = chessboard?.tipYArr[i], resultYArray[i].isRight == false {
                selectedWordArray.append(word)
            }
        }
        if selectedWordArray.count > 0 {
            if let selectedGrid = selectedWordArray[randomInt(selectedWordArray.count)].grid.first, selectedGrid.count >= 2 {
                let tagIndex = selectedGrid[1] * chessboardColumns * 100 + selectedGrid[0] + 100000
                if let button = chessboardView.viewWithTag(tagIndex) as? ZYChessboardButton {
                    chessboardView.chessboardButtonClick(sender: button)
                }
            }
        }else {
            allRight()
        }
    }
    func allRight() {
        let option = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        option.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        option.addAction(UIAlertAction(title: "重置", style: .default) { (action) in
//            self.resetValueClosure!(sender.center)
        })
        self.present(option, animated: true, completion: nil)
    }
    fileprivate func randomInt(_ max:Int) -> Int {
        return Int(arc4random_uniform(UInt32(max)))
    }
}
