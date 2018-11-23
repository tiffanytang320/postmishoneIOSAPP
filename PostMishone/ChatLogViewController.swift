//
//  ChatLogController.swift
//  PostMishone
//
//  Created by Tiffany Tang on 21/11/2018.
//  Copyright © 2018 Victor Liang. All rights reserved.
//

import UIKit
import Firebase

class ChatLogViewController: UICollectionViewController, UITextFieldDelegate{
    
   /* var usera: User? {
       didSet{
           //navigationItem.title = user?.email
             self.navigationItem.title = "hello"
            print("user changed")
        print(usera)
        }
    }*/
    
    var usera = User()
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        
        setupInputComponents()
        
     //   print(user.id as Any)
      //  print(user)

        self.navigationItem.title = "try"
        
    }
    
    func setupInputComponents(){
        let containerView = UIView()

        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        // Place the text field box at the bottom
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //initialize Send Button
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        // Place send button
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        // Init "Enter message..."
        containerView.addSubview(inputTextField)
        
        // Place "Enter message..."
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: 8).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor.black
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    // send message to database
    @objc func handleSend(){
        let ref = Database.database().reference().child("Messages")
        let childRef = ref.childByAutoId()
        print(usera as Any)
        let toId = "why cant you work"
        let fromId = Auth.auth().currentUser!.uid
        let timeStamp = Int(NSDate.timeIntervalSinceReferenceDate*1000)
        let values = ["text": inputTextField.text!, "toId": toId as Any, "fromId": fromId, "timeStamp": timeStamp]
        childRef.updateChildValues(values)
    }
    
    @objc func setReceiver(user: User){
            self.usera = user
    }

    // set "enter" as the send button also
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
