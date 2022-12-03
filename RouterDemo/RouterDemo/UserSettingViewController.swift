//
//  UserSettingViewController.swift
//  RouterDemo
//
//  Created by zhanggenlin on 2022/12/3.
//

import UIKit

class UserSettingViewController: UIViewController {
    
    var testKey: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "设置"
        self.view.backgroundColor = UIColor.white
        
        guard let key = self.testKey else {
            print("未传值")
            return
        }
        
        print(key)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
