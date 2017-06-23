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
        if let gridArray = chessboard?.grid {
            chessboardView.creatButton(with: gridArray)
            chessboardView.chessboardButtonClosure = { sender -> (landscapeIntro: [Array<Int>], portraitIntro: [Array<Int>]) in
                var landscapeIntro = [Array<Int>]()
                var portraitIntro = [Array<Int>]()
                var landscapeResultIntro: ZYBaseWord?
                var portraitResultIntro: ZYBaseWord?
                for i in 0 ..< self.chessboard!.tipXArr.count {
                    let XWord = self.chessboard!.tipXArr[i]
                    for num in XWord.grid {
                        if sender.column == num[0] && sender.row == num[1] {
                            landscapeResultIntro = self.resultXArray[i]
                            landscapeIntro = XWord.grid
                            break
                        }
                    }
                }
                for i in 0 ..< self.chessboard!.tipYArr.count {
                    let YWord = self.chessboard!.tipYArr[i]
                    for num in YWord.grid {
                        if sender.column == num[0] && sender.row == num[1] {
                            portraitResultIntro = self.resultYArray[i]
                            portraitIntro = YWord.grid
                            break
                        }
                    }
                }
                self.reloadCrosswordData(landscape: landscapeResultIntro, portrait: portraitResultIntro)
                return (landscapeIntro, portraitIntro)
            }
        }
    }
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
    @IBAction func allDataButtonClick(_ sender: UIButton) {
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
extension ZYChessboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return crosswordDataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CrosswordDataCellID", for: indexPath)
        return cell
    }
}
