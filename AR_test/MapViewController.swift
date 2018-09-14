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
        
        if let tabBarController = self.tabBarController as? TabBarController {
            tabBarController.mapViewController = self
        }
        
        
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
            print("MYLOCATION: \(userLocation)")
        }

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

extension MapViewController {
    func addNewTreasureHunt(withTitle title: String, text: String) {
        print("TITLE: \(title), TEXT: \(text)")
        if let userLocation = locationManager.location {
            TreasureHuntModel.newTreasureHuntAtLocation(userLocation, title: title, text: text) {
                data, response, error in
                print("Cool")
            }
            print("MYLOCATION: \(userLocation)")
        }
    }
    
    func scanForClues() {
        if let userLocation = locationManager.location {
            ClueNodeModel.getClueNodesNearLocation(userLocation) {
                data, response, error in
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        guard let clues = jsonResult["clues"] as? NSArray else { return }
                        var clueObjArr:[Clue] = []
                        for clue in clues {
                            guard let clue = clue as? NSDictionary else { continue }
                            let clueObj = Clue(title: clue.value(forKey: "title") as! String,
                                               uniqueID: clue.value(forKey: "unique_id") as! String,
                                               text: clue.value(forKey: "text") as! String)
                            clueObjArr.append(clueObj)
                        }
                        
                        DispatchQueue.main.async {
                            if let tabBarController = self.tabBarController as? TabBarController {
                                if let ARVC = tabBarController.arViewController {
                                    ARVC.didFindNewClues(clueObjArr)
                                }
                            }
                        }
                    }
                } catch {
                    print("ERROR")
                }
            }
            print("MYLOCATION: \(userLocation)")
        }
    }
}
