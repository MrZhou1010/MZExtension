//
//  MZCardTableViewVC.swift
//  MZExtension
//
//  Created by Mr.Z on 2020/5/11.
//  Copyright © 2020 Mr.Z. All rights reserved.
//

import UIKit

class MZCardTableViewVC: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = UIColor.clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.tableView.frame = CGRect(x: 15, y: 64, width: self.view.bounds.size.width - 30, height: self.view.bounds.size.height - 64)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.view.addSubview(self.tableView)
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension MZCardTableViewVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section % 2 == 0 ? 1 : 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.backgroundColor = UIColor(hexString: "#666666")
        cell.textLabel?.textColor = UIColor.random()
        cell.textLabel?.text = "第\(indexPath.section)组\(indexPath.row)行"
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.createCellCorner(with: tableView, indexPath: indexPath, cornerRadius: 8.0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 40.0))
        headerView.backgroundColor = UIColor.white
        let titleLab = UILabel.init(frame: headerView.bounds)
        titleLab.text = "第\(section)组"
        titleLab.textColor = UIColor.random()
        titleLab.font = UIFont.systemFont(ofSize: 15)
        titleLab.textAlignment = .left
        headerView.addSubview(titleLab)
        return headerView
    }
}
