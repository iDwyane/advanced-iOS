//
//  ViewController.swift
//  DWAlert
//
//  Created by apple on 17/5/17.
//  Copyright © 2017年 DWade. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    @IBAction func ClickMe(_ sender: Any) {
        let alert = DWAlert(alertTitle: "注意", alertContent: "流星坠落效果来了😝", title: "确定")
        alert.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

