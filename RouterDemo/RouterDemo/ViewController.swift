//
//  ViewController.swift
//  RouterDemo
//
//  Created by zhanggenlin on 2022/12/3.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "首页"
        self.view.backgroundColor = UIColor.white
        let btn = UIButton(type: UIButton.ButtonType.custom)
        
        btn.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        btn.backgroundColor = UIColor.gray
        
        btn.addTarget(self, action: #selector(btnClick), for: UIControl.Event.touchUpInside)
        
        self.view.addSubview(btn)
        
    }
    
    @objc func btnClick() {
//        RouterUtil.pushVC(target: RouterType.setting, params: ["testKey":123123])
        
        RouterUtil.pushVC(target: "setting", params: ["testKey":123123])
    }


}

