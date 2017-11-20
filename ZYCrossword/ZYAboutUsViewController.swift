//
//  ZYAboutUsViewController.swift
//  ZYCrossword
//
//  Created by 朱勇 on 2017/11/10.
//  Copyright © 2017年 ZhuYong. All rights reserved.
//

import UIKit

class ZYAboutUsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var aboutUsTableView: UITableView!
    func initView() {
        aboutUsTableView.tableFooterView = UIView()
        versionLabel.text = "v \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "")"
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
extension ZYAboutUsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.textLabel?.text = "游戏指南"
            cell.detailTextLabel?.text = ""
        }else if indexPath.row == 1 {
            cell.textLabel?.text = "邀请好友"
            cell.detailTextLabel?.text = "奖励50金币"
        }else if indexPath.row == 2 {
            cell.textLabel?.text = "鼓励评分"
            cell.detailTextLabel?.text = ""
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {// 游戏指南
            performSegue(withIdentifier: "handbookSegurId", sender: tableView)
        }else if indexPath.row == 1 {// 邀请好友
            
        }else if indexPath.row == 2 {// 鼓励评分
            
        }
    }
}
