//
//  UITabBarController.swift
//  PostMishone
//
//  Created by Victor Liang on 2018-11-07.
//  Copyright © 2018 Victor Liang. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    // For setting the default tab to load on launch
    
    @IBInspectable var defaultIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
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
