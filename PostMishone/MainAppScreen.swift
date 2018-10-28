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

// Custom class for missions
// class customMissionPin: NSObject, MKAnnotation {
//    var coordinate: CLLocationCoordinate2D
//    var title: String?
//    var subtitle: String?
//
//    init(PinTitle:String, pinSubTitle:String, location:CLLocationCoordinate2D) {
//        self.title = PinTitle
//        self.subtitle = pinSubTitle
//        self.coordinate = location
//    }
// }

class MainAppScreen: UIViewController {
    
    var ref: DatabaseReference!
    var dataBaseHandle: DatabaseHandle!
    var missionPostsArray = [MKPointAnnotation]()
    
    var longitude : Double = 0.0
    var latitude : Double = 0.0
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let displayRegionInMeters : Double = 1600
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self // For showing annotation when pin is tapped
        ref = Database.database().reference() // Firebase Reference
        checkLocationServices() // Check user location settings -> initiate user map
        
        // Retreive Mission Posts and listen for changes
        dataBaseHandle = ref?.child("PostedMissions").observe(.childAdded , with: { (snapshot) in
            
            // Code to execute when a child is added under "PostedMissions"
            // MARK: Point Annotation Creation
            // Take value from snapshot and add it to missionPostsArray
            if let dic = snapshot.value as? [String:Any], let _ = dic["timeStamp"] as? Int, let latitude = dic["Latitude"] as? Double, let longitude = dic["Longitude"] as? Double, let missionName = dic["missionName"] as? String, let missionDescription = dic["missionDescription"] as? String {

                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude , longitude: longitude )
                
                annotation.title = missionName
                annotation.subtitle = missionDescription
                self.mapView.addAnnotation(annotation)

                self.missionPostsArray.append(annotation)
    
                self.addAllPostedMissionsAnnotations() // !!! might need to change this
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
        }
    }
    
    
    // Prepares pin coordinate information to send to describeMissionViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let describeMissionVC = segue.destination as? DescribeMissionViewController else { return }
        describeMissionVC.latitude = latitude
        describeMissionVC.longitude = longitude
    }

    
    // Upadates map with all annotations in missionPostsArray
    func addAllPostedMissionsAnnotations() {
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
        }
        return view
    }
}
