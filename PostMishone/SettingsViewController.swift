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
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseStorage
import SwiftyJSON

class SettingsViewController: UIViewController {
    @IBOutlet weak var uiimgvpropic: UIImageView!
    @IBOutlet weak var uiname: UILabel!
    @IBOutlet weak var uiemail: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // make profile round
        self.uiimgvpropic.layer.cornerRadius = self.uiimgvpropic.frame.size.width/2
        self.uiimgvpropic.clipsToBounds = true
        
        if FBSDKAccessToken.current() != nil {
        if let user = Auth.auth().currentUser {
            // user signed in
            let name = user.displayName
            let email = user.email
            let photoUrl = user.photoURL
            let uid = user.uid
            
            
            self.uiname.text = name
            self.uiemail.text = email
            
            let data = NSData(contentsOf: photoUrl!)
            self.uiimgvpropic.image = UIImage(data: data! as Data)
            
            // reference to firebase storage
            let storage = Storage.storage()
            // refer our storage service
            let storageRef = storage.reference(forURL: "gs://postmishone.appspot.com")
            
            FBSDKGraphRequest(graphPath: "me/picture", parameters: ["height":300, "width":300, "redirect": false])?.start(completionHandler: { (connection, result, err) in
                if err == nil {
                    let json = JSON(result)
                    print(json["data"]["url"].stringValue)
                } else {
                    print("Failed to start graph request", err)
                    return
                }
                
                })
            
            
//            var profilePic = FBSDKGraphRequest(graphPath: "me/picture", parameters: ["height":300, "width":300, "redirect": false], httpMethod: "GET")
//            profilePic?.start(completionHandler: {(connection, result, error) -> Void in
//
//                if error == nil {
//                    let dictionary = result as? NSDictionary
//                    let data = dictionary?.object(forKey: "data")
//
//                    let urlPic = (data?.object(forKey: "url"))! as! String
//
//                    if let imageData = NSData(contentsOf: NSURL(string:urlPic)) {
//                        let profilePicRef = storageRef.child(user.uid+"/profile_pic.jpg")
//
//                        let uploadTask = profilePicRef.putData(imageData, metadata: nil){
//                            metadata,error in
//
//                            if(error == nil) {
//                                let downloadUrl = metadata!.downloadURL
//                            } else {
//                                print("Error in downloading image")
//                            }
//                        }
//
//                    }
//                }
//
//            })
            
        } else {
            // no user is signed in
        }
    }
        let user = Auth.auth().currentUser
        let name = user?.displayName
        let email = user?.email
        self.uiname.text = name
        self.uiemail.text = email
        view.accessibilityIdentifier = "SettingsViewController" // Identifier for UI Testing

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
}
    
    @IBAction func handleLogOut(_ sender: Any) {
        try! Auth.auth().signOut()
        FBSDKAccessToken.setCurrent(nil)
        self.dismiss(animated: true, completion: nil)
        print("Log out success")
    }
    
}
