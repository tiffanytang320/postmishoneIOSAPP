//
//  ChatTableViewController.swift
//  PostMishone
//
//  Created by Tiffany Tang on 21/11/2018.
//  Copyright © 2018 Victor Liang. All rights reserved.
//

import UIKit
import Firebase

class ChatTableViewController: UITableViewController {
    var ref: DatabaseReference!
    var myMissions = [String]()
    var missionIDS = [String]()
    let userID = Auth.auth().currentUser!.uid

    override func viewDidLoad() {

        super.viewDidLoad()
        
        ref = Database.database().reference().child("Messages") // Firebase Reference
        
        self.navigationItem.title = "tiff"
        // that icon on the top right
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem(rawValue: 7)!, target: self, action: #selector(handleNewMessage))

        observeMessages()
        
    }
    
    func observeMessages(){
        let ref = Database.database().reference().child("Users").child(userID)
    }
    
   // var chatLogController: ChatLogViewController?
    
    @objc func showChatControllerForUser(user: User){
       // let chatLogController = ChatLogViewController(collectionViewLayout: UICollectionViewLayout())
       //let chatLogController = ChatLogViewController()
      //  let chatLogController = segue!.destination as! ChatLogViewController

     //   chatLogController.user = user
      //  chatLogController.user!.id = user.id
        
       // self.chatLogController?.setReceiver(user: user)
         ChatLogViewController().setReceiver(user: user)
      //  print(chatLogController.user!.id as Any)
        print("end")
        self.performSegue(withIdentifier: "toChatLog", sender: self)
        print("123456")
    }
    

    @objc  func handleNewMessage(){
        let newMessageController = NewMessageTableViewController()
        newMessageController.chattableController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController , animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}
