//
//  LoginViewController.swift
//  PostMishone
//
//  Created by Victor Liang on 2018-10-14.
//  Copyright © 2018 Victor Liang. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController : UIViewController, GIDSignInUIDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        view.accessibilityIdentifier = "LoginViewController"
        
        
        setupGoogleButtons()
    }
    
    fileprivate func setupGoogleButtons() {
        //Google sign in button
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x:16, y: 116 + 380, width: view.frame.width - 32, height: 50)
        view.addSubview(googleButton)
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        // Check user authentication, bring to mainAppScreen when ready
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if user != nil && error == nil {
                self.navigationController?.popViewController(animated: false)
                print("Log in success")
            }
            else {
                print(error!)
                print(self.emailTextField.text!)
                print(self.passwordTextField.text!)
            }
        }

        
    }
    
    

}
