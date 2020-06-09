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
        // Do any additional setup after loading the view.
        
        let view = UIView(frame: CGRect(x: 100, y: 200, width: 100, height: 200))
        view.backgroundColor = UIColor.red
        self.view.addSubview(view)
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 80, y: 80, width: 40, height: 40)
        btn.backgroundColor = UIColor.blue
        btn.addTarget(self, action: #selector(btnClicked(btn:)), for: .touchUpInside)
        // 扩充按钮的点击区域
        btn.mz_clickEdgeInsets = UIEdgeInsets(top: 80, left: 30, bottom: 80, right: 30)
        view.addSubview(btn)
    }
    
    @objc func btnClicked(btn: UIButton) {
        btn.backgroundColor = UIColor.random()
        let vc = MZCardTableViewVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
