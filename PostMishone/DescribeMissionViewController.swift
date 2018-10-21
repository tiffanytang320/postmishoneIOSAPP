//
//  DescribeMissionViewController.swift
//  PostMishone
//
//  Created by Victor Liang on 2018-10-14.
//  Copyright © 2018 Victor Liang. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class DescribeMissionViewController: UIViewController {
    var ref: DatabaseReference!
    var latitude = 0.0
    var longitude = 0.0

    @IBOutlet weak var missionName: UITextField!
    @IBOutlet weak var missionDescription: UITextField!
    @IBOutlet weak var reward: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        missionName.delegate = self
        missionDescription.delegate = self
        reward.delegate = self
        

        // Do any additional setup after loading the view.
        ref = Database.database().reference() //Firebase Reference

    }
    
    
    
    @IBAction func postMissionPressed(_ sender: Any) {
        let userID = Auth.auth().currentUser!.uid
        let timeStamp = Int(NSDate.timeIntervalSinceReferenceDate*1000)
        
        print("Describe Mission View Controller:")
        print("lat: ", latitude)
        print("long: ", longitude)
        print("userID: ", userID)
        print("timeStamp: ", timeStamp)
        print("missionNameText: ", missionName.text!)
        print("missionDescription: ", missionDescription.text!)
        print("reward: ", reward.text!)
        
        ref?.child("PostedMissions").childByAutoId().setValue(["Latitude": latitude, "Longitude": longitude, "UserID": userID, "timeStamp": timeStamp, "missionName": missionName.text!, "missionDescription": missionDescription.text!, "reward": reward.text!])

        print("Mission Posted!")

    self.navigationController?.popViewController(animated: true)
    

        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

/*make keyboard close on return*/
extension DescribeMissionViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
