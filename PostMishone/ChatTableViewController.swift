//
//  ChatTableViewController.swift
//  PostMishone
//
//  Created by Tiffany Tang on 21/11/2018.
//  Copyright © 2018 Victor Liang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class Message: NSObject{
    
    var fromId: String?
    var text: String?
    var timeStamp: Int?
    var toId: String?
}

class ChatTableViewController: UITableViewController {
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser!.uid
    var usera = User() 

    override func viewDidLoad() {

        super.viewDidLoad()
        
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    
        
        // that icon on the top right
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem(rawValue: 7)!, target: self, action: #selector(handleNewMessage))

        observeMessages()
        
    }
    
    var messages = [Message]()
    
    // Show the list of messages on chat table view page
    func observeMessages(){
        let ref = Database.database().reference().child("Messages")
        ref.observe(.childAdded, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let message = Message()
          
                message.toId = dictionary["toId"] as? String
                message.fromId = dictionary["fromId"] as? String
                message.timeStamp = dictionary["timeStamp"] as? Int
                message.text = dictionary["text"] as? String
                self.messages.append(message)
                
                DispatchQueue.main.async(execute: {self.tableView.reloadData()})
            }        
            
        }, withCancel: nil)
    }
    
   // directing to chatlog view accoring to the person you want to talk to
    @objc func showChatControllerForUser(user: User){
        let chatLogController = ChatLogViewController(collectionViewLayout: UICollectionViewFlowLayout())
        //ChatLogViewController().setTitle(user: user)
        
        chatLogController.usera = user
        self.usera = user
        
        print("end")
        self.performSegue(withIdentifier: "toChatLog", sender: self)
        print("123456")
    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?){
        var vc = segue.destination as! ChatLogViewController
        vc.usera = usera
    }
    
    // when new message button is pressed
    @objc  func handleNewMessage(){
        let newMessageController = NewMessageTableViewController()
        newMessageController.chattableController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController , animated: true, completion: nil)
    }
    // MARK: - Table view data source

    // data showing in each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        let message = messages[indexPath.row]
        
        if let toId = message.toId{
            let ref = Database.database().reference().child("Messages").child(toId)
            ref.observeSingleEvent(of: .value, with: {(snapshot)
                in

                if let dictionary = snapshot.value as? [String: AnyObject]
                {
                    cell.textLabel?.text = dictionary["username"] as? String           ////////CHANGE THIS TO NAME
                }
                
            }, withCancel: nil)
        }
        
        cell.textLabel?.text = message.toId
        cell.detailTextLabel?.text = message.text
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
   /* override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let message = messages[indexPath.row]
        print(message.text, message.toId, message.fromId)
        
        showChatControllerForUser(user: User)

    }*/

}


