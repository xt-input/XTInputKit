//
//  XTINavigationController.swift
//  XTInputKitDemo
//
//  Created by Input on 2018/1/29.
//  Copyright © 2018年 input. All rights reserved.
//

import UIKit

var i = 0

class XTINavigationController: UINavigationController {
    
    var j: Int! = i
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        i += 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func xti_openBackGesture() -> Bool {
        return j % 2 == 0
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
