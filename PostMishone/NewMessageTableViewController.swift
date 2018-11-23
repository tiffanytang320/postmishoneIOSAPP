//
//  NewMessageTableViewController.swift
//  PostMishone
//
//  Created by Tiffany Tang on 21/11/2018.
//  Copyright © 2018 Victor Liang. All rights reserved.
//

import UIKit
import Firebase

class User: NSObject{
    var name: String?
    var email: String?
    var password: String?
    var id: String?
}

class NewMessageTableViewController: UITableViewController {
    var ref: DatabaseReference!
    var myMissions = [String]()
    var missionIDS = [String]()
    let userID = Auth.auth().currentUser!.uid
    
    var users = [User]()
    let cellID = "cellID"


    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        
        fetchUser()
    }
    
    func fetchUser(){
        Database.database().reference().child("Users").observe(.childAdded, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let user = User()
                print("hi")
                user.id = snapshot.key
                print(user.id!)
                
                user.email = dictionary["email"] as? String
                self.users.append(user)
                print(self.users.count)
                DispatchQueue.main.async(execute: {self.tableView.reloadData()})
                   // self.tableView.reloadData()
            }
            
    } , withCancel: nil)
        

}

    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementati on, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.email
        cell.detailTextLabel?.text = user.email
        
        return cell
    }
    
    var chattableController: ChatTableViewController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true){
            print("Dismiss completed")
            let user = self.users[indexPath.row]
            print(user)
            self.chattableController?.showChatControllerForUser(user: user)
        }
    }
}


class UserCell: UITableViewCell{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
