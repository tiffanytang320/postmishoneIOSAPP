//
//  MainAppScreen.swift
//  PostMishone
//
//  Created by Victor Liang on 2018-10-14.
//  Copyright © 2018 Victor Liang. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MapKit
import CoreLocation

/*Custom class for missions*/
//class customMissionPin: NSObject, MKAnnotation {
//    var coordinate: CLLocationCoordinate2D
//    var title: String?
//    var subtitle: String?
//
//    init(PinTitle:String, pinSubTitle:String, location:CLLocationCoordinate2D) {
//        self.title = PinTitle
//        self.subtitle = pinSubTitle
//        self.coordinate = location
//    }
//}

class MainAppScreen: UIViewController {
    
    var ref: DatabaseReference!
    var dataBaseHandle: DatabaseHandle!
    var missionPostsArray = [MKPointAnnotation]()
    
    var longitude : Double = 0.0
    var latitude : Double = 0.0
//    var timeStamp : Int = 0
//    var userID : String = ""
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let displayRegionInMeters : Double = 1600
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference() //Firebase Reference
        checkLocationServices() //check user location settings -> initiate user map
//        self.PopDescribeMissionView.layer.cornerRadius = 10
        
        //Retreive Mission Posts and listen for changes
        dataBaseHandle = ref?.child("PostedMissions").observe(.childAdded , with: { (snapshot) in
            //Code to execute when a child is added under "PostedMissions
            
            //take value from snapshot and add it to  missionPostsArray
//             let latitude = snapshot.value(forKeyLOpbLyo4UsDmtud1RI0: "Latitude")
//            let latitude = snapshot.value(forKey: "Latitude")
//            let longitude = snapshot.value(forKey: "Longitude")
//            print(latitude)
            
            
            if let dic = snapshot.value as? [String:Any], let time = dic["timeStamp"] as? Int, let latitude = dic["Latitude"] as? Double, let longitude = dic["Longitude"] as? Double {

                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
                
                self.missionPostsArray.append(annotation)
    
                self.addAllPostedMissionsAnnotations()
                
            }
            
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
//
//            self.missionPostsArray.append(annotation)
//
//            self.addAllPostedMissionsAnnotations()
        })
        
    }
    
    // MARK: MAP FUNCTIONALITY
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center : location, latitudinalMeters : displayRegionInMeters, longitudinalMeters :  displayRegionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }

    /*Make sure location services are enabled on device*/
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            // set up location manager
            setupLocationManager()
            checkLocationAuthorization()

        }
        else {
            //alert user their location service is off
            print("location service disabled")
        }
    }


    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            //Do map stuff
            print("doing map stuff")
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()

            break
        case .denied:
            //Show alert how to turn on alert
            print("Denied")
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            print("Denied")
            //Show alert about whats up
            break
        case .authorizedAlways:
            break
        }
    }
    
    // MARK: LONG PRESS -> Pin Mission
    
    @IBAction func pinMission(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.ended {
            let touchLocation = sender.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation,toCoordinateFrom: mapView)
            
//            let missionpin = customMissionPin(PinTitle: <#T##String#>, pinSubTitle: <#T##String#>, location: <#T##CLLocationCoordinate2D#>)

            
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = CLLocationCoordinate2D(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
//            mapView.addAnnotation(annotation)
            

            
//            let userID = Auth.auth().currentUser!.uid
//            let timeStamp = Int(NSDate.timeIntervalSinceReferenceDate*1000)

            
            longitude = locationCoordinate.longitude
            latitude = locationCoordinate.latitude
//            userID = Auth.auth().currentUser!.uid
//            timeStamp = Int(NSDate.timeIntervalSinceReferenceDate*1000)

//            ref?.child("PostedMissions").childByAutoId().setValue(["Latitude": locationCoordinate.latitude, "Longitude": locationCoordinate.longitude, "UserID": userID, "timeStamp": timeStamp])
            
            self.performSegue(withIdentifier: "toDescribeMission", sender: self)

            print("Long pressed mission at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
        }
//        if sender.state == UIGestureRecognizer.State.began {
//            return
//        }

    
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let describeMissionVC = segue.destination as? DescribeMissionViewController else { return }
        describeMissionVC.latitude = latitude
        describeMissionVC.longitude = longitude
//        describeMissionVC.userID = userID
//        describeMissionVC.timeStamp = timeStamp
    }

    
    
    func addAllPostedMissionsAnnotations() { //reload map with all missions in array
        for annotation in missionPostsArray {
        mapView.addAnnotation(annotation)
        }
    }
    
    
    // MARK: Other
    @IBAction func test(_ sender: Any) {
        try! Auth.auth().signOut()
        print("logout")
        self.dismiss(animated: true, completion: nil)
    }
    

    //
//    @IBOutlet var PopDescribeMissionView: UIView!
//
//    @IBAction func popbutt(_ sender: Any) {
//        self.view.addSubview(PopDescribeMissionView)
//        PopDescribeMissionView.center = self.view.center
//    }
//
//    @IBAction func exitDescribMission(_ sender: Any) {
//        self.PopDescribeMissionView.removeFromSuperview()
//    }
}


// MARK: Map extension
extension MainAppScreen: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        //update location if location has changed
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: displayRegionInMeters, longitudinalMeters: displayRegionInMeters)
//        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        check if authorization changes, if so, check again
        checkLocationAuthorization()
    }
}
