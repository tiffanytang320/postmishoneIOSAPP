//
//  LoginViewController.swift
//  PostMishone
//
//  Created by Victor Liang on 2018-10-14.
//  Copyright © 2018 Victor Liang. All rights reserved.
//

//import Foundation
import UIKit
import Firebase
import GoogleSignIn

class LoginViewController : UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    @IBAction func loginTapped(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if user != nil && error == nil {
                self.navigationController?.popViewController(animated: false)
//                self.dismiss(animated: false, completion: nil)
                print("Log in success")
//                self.performSegue(withIdentifier: "toMainAppScreen", sender: self)
                
            }
            else {
                print(error!)
                print(self.emailTextField.text!)
                print(self.passwordTextField.text!)

            }
        }

        
    }

}
