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
    var resetValueClosure: ((_ point: CGPoint) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        creatChessboardViewData()
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
            let realm = try! Realm()
            let chessboards = realm.objects(ZYChessboard.self)
            try! realm.write {
                realm.delete(chessboards)
            }
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
            chessboardView.chessboardButtonClosure = { sender in
                
            }
        }
    }
    @IBOutlet weak var crosswordDataTableView: UITableView!
    @IBAction func allDataButtonClick(_ sender: UIButton) {
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
