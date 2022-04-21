//
//  ViewController.swift
//  MZExtension
//
//  Created by Mr.Z on 2019/12/12.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI() {
        let view = UIView(frame: CGRect(x: 100.0, y: 200.0, width: 100.0, height: 200.0))
        view.backgroundColor = UIColor.red
        self.view.addSubview(view)
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 80.0, y: 80.0, width: 40.0, height: 40.0)
        btn.backgroundColor = UIColor.blue
        btn.addTarget(self, action: #selector(btnClicked(btn:)), for: .touchUpInside)
        // 扩充按钮的点击区域
        btn.mz_clickEdgeInsets = UIEdgeInsets(top: 80.0, left: 80.0, bottom: 80.0, right: 80.0)
        view.addSubview(btn)
    }
    
    @objc private func btnClicked(btn: UIButton) {
        btn.backgroundColor = UIColor.random()
        let vc = MZCardTableViewVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
