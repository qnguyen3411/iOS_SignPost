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
    let regionRadius: CLLocationDistance = 1000
    
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
}
extension MapViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("OK")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR")
    }
}
