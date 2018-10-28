//
//  RegisterViewController.swift
//  PostMishone
//
//  Created by Victor Liang on 2018-10-14.
//  Copyright © 2018 Victor Liang. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class RegisterViewController : UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func registerTapped(_ sender: Any) {
        // Set up a new user on our Firebase database
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil && user != nil {
                self.navigationController?.popViewController(animated: false)


                print("Registration Successful")
                
                // MARK: User Profile Creation !!!
                // Username database entry
//                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
//                changeRequest?.displayName = username
//                changeRequest?.commitChanges { error in
//                    if error == nil {
//                        print("User name changed")
//                    }
//                }
//
                
            } else {
                print("Error registering")
                print(error!)
                
            }
        }
    }
    

}
