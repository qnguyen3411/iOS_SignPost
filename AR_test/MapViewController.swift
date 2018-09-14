//
//  MapViewController.swift
//  AR_test
//
//  Created by Quang Nguyen on 9/13/18.
//  Copyright © 2018 Quang Nguyen. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    let regionRadius: CLLocationDistance = 1
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        print("MAPVIEW LOADED")
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        // 3
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
        // Do any additional setup after loading the view.
        }
        if let userLocation = locationManager.location {
            centerMapOnLocation(location: userLocation)
        }

    }
    
    @IBAction func findTreasureHuntButtonPressed(_ sender: UIButton) {
//        performSegue(withIdentifier: "NewFormSegue", sender: )
    }
    
    @IBAction func newTreasureHuntButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "NewFormSegue", sender: sender)
    }
    
    @IBAction func newNodeButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "NewFormSegue", sender: sender)
    }
    
    @IBAction func findNodeButtonPressed(_ sender: UIButton) {
    }
    
    
    
}

extension MapViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude,
                                                             userLocation.coordinate.longitude);
        myAnnotation.title = "Current location"
        mapView.addAnnotation(myAnnotation)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR")
    }
}
