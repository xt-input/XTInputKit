//
//  XTIDivViewController.swift
//  XTInputKit
//
//  Created by Input on 2018/9/17.
//  Copyright © 2018年 input. All rights reserved.
//

import UIKit

class XTIDivViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var tempView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        tempView.center = self.view.center
        self.view?.addSubview(tempView)
        for _ in 0 ... 10 {
            let temp1View = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            tempView.addSubview(temp1View)
            tempView = temp1View
        }
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
