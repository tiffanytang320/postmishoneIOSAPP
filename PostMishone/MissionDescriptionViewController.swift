//
//  MissionDescriptionViewController.swift
//  PostMishone
//
//  Created by Victor Liang on 2018-11-04.
//  Copyright © 2018 Victor Liang. All rights reserved.
//

import UIKit
import Firebase

class MissionDescriptionViewController: UIViewController {
    var ref: DatabaseReference!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference() // Firebase Reference
//        ref.child("users").child ///TODO
        
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
