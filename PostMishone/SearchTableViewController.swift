//
//  SearchTableViewController.swift
//  PostMishone
//
//  Created by Victor Liang on 2018-11-21.
//  Copyright © 2018 Victor Liang. All rights reserved.
//

import UIKit
import Firebase

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    var searchActive : Bool = false // Temp
    var missionsArray = [Mission]()
    var currentMissionsArray = [Mission]() // new array based on search query
    var ref: DatabaseReference!

    
    @IBOutlet weak var missionName: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        ref = Database.database().reference() //Firebase Reference
        
//        missionsArray.append(Mission(missionName: "Mission 1", missionDescription: "HEHEH", category: .mission))
//        missionsArray.append(Mission(missionName: "Mission 2", missionDescription: "HEHEH", category: .mission))
//        missionsArray.append(Mission(missionName: "Mission 3", missionDescription: "HEHEH", category: .mission))
        
//        currentMissionsArray = missionsArray
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missionsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableViewCell else { return UITableViewCell() }
        cell.missionName.text = missionsArray[indexPath.row].missionName
        cell.missionDescription.text = missionsArray[indexPath.row].missionDescription
        cell.missionReward.text = missionsArray[indexPath.row].missionReward
        return cell
    }
    
    // Set height of each cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // 100 pixels tall
    }
    
    
    // MARK: SEARCH BAR
    
    // Search bar behaviour to determine when the user is 'searching'
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchActive = true;
//    }
//
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.tableView.reloadData()
        print("ended")
    }
//
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchActive = false;
        print("cancelled")
        print(missionsArray.count)
    }
//
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchActive = false;
//        self.view.endEditing(true)
//        searchBar.resignFirstResponder()
        self.searchDisplayController.active = false;

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        missionsArray.removeAll()
        ref.child("PostedMissions").queryOrdered(byChild: "missionName").queryStarting(atValue: searchText).queryEnding(atValue: searchText + "\u{f8ff}").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                print("FOR LOOP")
                let snap = child as! DataSnapshot
                if let dic = snap.value as? [String:Any], let missionName = dic["missionName"] as? String, let missionDescription = dic["missionDescription"] as? String, let reward = dic["reward"] as? String {
                    self.missionsArray.append(Mission(missionName: missionName, missionDescription: missionDescription, missionReward: reward, category: .mission))
                    print(self.missionsArray.count)
                    self.tableView.reloadData()
                }
            }
            self.tableView.reloadData()

            
        }
    }

}

class Mission {
    let missionName: String
    let missionDescription: String
    let missionReward: String
    let category: Type
    // TODO: add image
    
    init(missionName: String, missionDescription: String, missionReward: String, category: Type) {
        self.missionName = missionName
        self.missionDescription = missionDescription
        self.missionReward = missionReward
        self.category = category
    }
}

enum Type: String {
    case mission = "Mission"
    case person = "Person"
}



