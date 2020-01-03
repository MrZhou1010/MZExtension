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
        
        var tempStr = "123456" as NSString
        let enResult = tempStr.aesEncrypt(withKey: "88888888", type: .type128)
        tempStr = "205a33ee54e15937d3cc1ca010b468ee"
        let deResult = tempStr.aesDecrypt(withKey: "88888888", type: .type128)
        print(enResult)
        print(deResult)
    }
}

