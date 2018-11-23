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

// Custom class for missions: (replacing MKAnnotation)
 class missionAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var missionPosterID: String?
    var timeStamp: Int?
    var reward: String?
    var missionID: String?
    
    init(title:String, subtitle:String, location:CLLocationCoordinate2D, posterID:String, timeStamp:Int, reward:String, missionID:String) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = location
        self.missionPosterID = posterID
        self.timeStamp = timeStamp
        self.reward = reward
        self.missionID = missionID
    }
 }

class MainAppScreen: UIViewController {
    var ref: DatabaseReference!
    var dataBaseHandle: DatabaseHandle!
    var missionPostsArray = [missionAnnotation]()
    var selectedAnnotation: missionAnnotation?
    var longitude : Double = 0.0
    var latitude : Double = 0.0
    let userID = Auth.auth().currentUser!.uid
    var tempanno: missionAnnotation?
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let displayRegionInMeters : Double = 1600
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self // For showing annotation when pin is tapped
        ref = Database.database().reference() // Firebase Reference
        checkLocationServices() // Check user location settings -> initiate user map
        
//        let mission = missionAnnotation(title: "custom annotation", subtitle: "custom sub", location: CLLocationCoordinate2D(latitude: 49.26044, longitude: -123.24), posterID: "customposterID")
//        self.mapView.addAnnotation(mission)
        
        // Retreive Mission Posts and listen for changes
        dataBaseHandle = ref?.child("PostedMissions").observe(.childAdded, with: { (snapshot) in
            print("FIREBASEobservedAdded")
            // Code to execute when a child is added under "PostedMissions"
            // MARK: missionAnnotation Creation
            // Take value from snapshot and add it to missionPostsArray
            if let dic = snapshot.value as? [String:Any], let timeStamp = dic["timeStamp"] as? Int, let latitude = dic["Latitude"] as? Double, let longitude = dic["Longitude"] as? Double, let missionName = dic["missionName"] as? String, let missionDescription = dic["missionDescription"] as? String, let posterID = dic["UserID"] as? String, let reward = dic["reward"] as? String, let missionID = dic["missionID"] as? String {

                let annotation = missionAnnotation(title: missionName, subtitle: missionDescription, location: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), posterID: posterID, timeStamp: timeStamp, reward: reward, missionID: missionID)

//                self.mapView.addAnnotation(annotation)
                self.tempanno = annotation
                self.missionPostsArray.append(annotation)
                self.mapView.addAnnotations(self.missionPostsArray)
                
            }
        })
        
        //Deleting missions
        ref?.child("PostedMissions").observe(.childRemoved, with: { (snapshot) in
            print("FIREBASEobservedRemove")
            if let dic = snapshot.value as? [String:Any], let missionID = dic["missionID"] as? String {
                
                let deletedMission = self.missionPostsArray.filter{$0.missionID == missionID}
                
                self.mapView.removeAnnotations(deletedMission)
                
                let filteredMissions = self.missionPostsArray.filter{$0.missionID != missionID}
                
                
                self.missionPostsArray = filteredMissions
                
                print("DELETE")
                
            }
            
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
    
    // Make sure location services are enabled on device
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            // Set up location manager
            setupLocationManager()
            checkLocationAuthorization()
        }
        else {
            // Alert user their location service is off
            print("location service disabled")
        }
    }
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            // Do map stuff
            print("doing map stuff")
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert "how to turn on alert"
            print("Denied")
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            print("Denied")
            // Show alert about whats up
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
            
            longitude = locationCoordinate.longitude
            latitude = locationCoordinate.latitude
            
            self.performSegue(withIdentifier: "toDescribeMission", sender: self)
            
            print("Long pressed mission at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            print("Total annotations: \(mapView.annotations.count)")
        }
    }
    
    // Prepares pin coordinate information to send to describeMissionViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDescribeMission" {
            let destination = segue.destination as? DescribeMissionViewController
            destination?.latitude = latitude
            destination?.longitude = longitude
        }
        if segue.identifier == "toMissionDescription" {
            let destination = segue.destination as? MissionDescriptionViewController
            destination?.missionTitle = selectedAnnotation?.title ?? ""
            destination?.subtitle = selectedAnnotation?.subtitle ?? ""
            destination?.posterID = selectedAnnotation?.missionPosterID ?? ""
            destination?.reward = selectedAnnotation?.reward ?? ""
            destination?.missionID = selectedAnnotation?.missionID ?? ""
            
        }
    }
    
    

    
    
}


// MARK: Map extension
extension MainAppScreen: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.last != nil else {
            return
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Check if authorization changes, if so, check again
        checkLocationAuthorization()
    }
    
}

extension MainAppScreen: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil } // Do not touch UserLocation

        let identifier = "marker"
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            if let annotation = view.annotation as? missionAnnotation {
                if(annotation.missionPosterID == userID) { // Render marker color, differentiate own missions from others // TODO: helper function to classify missions
                    view.markerTintColor = UIColor.blue;
                }
            }
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("info")
        self.performSegue(withIdentifier: "toMissionDescription", sender: self)
    }
    
    
    // MARK: SELECT ANNOTATION -> Identify selected annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? missionAnnotation {
            selectedAnnotation = annotation;
            print("selected posterID: \(String(describing: annotation.missionPosterID))")
            print("selected reward: \(String(describing: annotation.reward))")
            print("selected timeStamp: \(String(describing: annotation.timeStamp))")
        }
    }
    
    
}
