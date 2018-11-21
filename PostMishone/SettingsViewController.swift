//
//  SettingsViewController.swift
//  PostMishone
//
//  Created by Victor Liang on 2018-10-14.
//  Copyright © 2018 Victor Liang. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "SettingsViewController" // Identifier for UI Testing

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
}
    
    @IBAction func handleLogOut(_ sender: Any) {
//        print("logout")
//        try! Auth.auth().signOut()
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
