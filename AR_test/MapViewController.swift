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
    let nearbyTreasureHunts:[CLLocation] = []
    
    
    @IBOutlet weak var mapView: MKMapView!
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    let regionRadius: CLLocationDistance = 1
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getNearbyTreasureHunts()
    }
    
    override func viewDidLoad() {
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
        }
    }
}

extension MapViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        
        mapView.setRegion(region, animated: true)
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude,
                                                             userLocation.coordinate.longitude);
        myAnnotation.title = "You Are Here"
        mapView.addAnnotation(myAnnotation)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR")
    }
}

extension MapViewController {
    func getNearbyTreasureHunts() {
        if let userLocation = locationManager.location {
            TreasureHuntModel.getTreasureHuntsNearLocation(userLocation){
                data, response, error in
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        guard let treasureHunts = jsonResult["treasure_hunts"] as? NSArray else { return }
                        for treasureHunt in treasureHunts {
                            guard let treasureHunt = treasureHunt as? NSDictionary else { continue }
                            guard let title = treasureHunt["title"] as? String else {continue}
                            guard let latitude = treasureHunt["latitude"] as? Double else {continue}
                            guard let longitude = treasureHunt["longitude"] as? Double else {continue}
                            
                            DispatchQueue.main.async {
                                let myAnnotation: MKPointAnnotation = MKPointAnnotation()
                                myAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                                myAnnotation.title = title
                                self.mapView.addAnnotation(myAnnotation)
                            }
                        }
                    }
                } catch {
                    print("ERROR")
                }
            }
        }
    }
    
    
    func addNewTreasureHunt(withTitle title: String, text: String) {
        if let userLocation = locationManager.location {
            TreasureHuntModel.newTreasureHuntAtLocation(userLocation, title: title, text: text) {
                data, response, error in
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        guard let uniqueID = jsonResult["unique_id"] as? NSString else {
                            return
                        }
                        print("GOT UNIQUE ID: \(uniqueID)")
                        DispatchQueue.main.async {
                            if let tabBarController = self.tabBarController as? TabBarController {
                                if let newTreasureHuntVC = tabBarController.newTreasureHuntController {
                                    newTreasureHuntVC.displaySuccessFeedback(withUniqueID: uniqueID as String)
                                }
                            }
                        }
                    }
                } catch {
                    print("ERROR")
                }
            }
        }
    }
    
    func addNewNode(withTitle title: String, text: String, prevID:String) {
        if let userLocation = locationManager.location {
            ClueNodeModel.addNewClueNodeAtLocation(userLocation, title: title, text: text, prevNodeId: prevID){
                data, response, error in
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        guard let uniqueID = jsonResult["unique_id"] as? NSString else {
                            return
                        }
                        print("GOT UNIQUE ID: \(uniqueID)")
                        DispatchQueue.main.async {
                            if let tabBarController = self.tabBarController as? TabBarController {
                                if let newClueVC = tabBarController.newClueViewController {
                                    newClueVC.displaySuccessFeedback(withUniqueID: uniqueID as String)
                                }
                            }
                        }
                    }
                    
                } catch {
                    print("ERROR")
                }
            }
        }
    }
    
    
    
    func scanForClues() {
        if let userLocation = locationManager.location {
            ClueNodeModel.getClueNodesNearLocation(userLocation) {
                data, response, error in
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        guard let clues = jsonResult["clues"] as? NSArray else {
                            return
                        }
                        var clueObjArr:[Clue] = []
                        for clue in clues {
                            guard let clue = clue as? NSDictionary else {
                                continue
                            }
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
        }
    }
}
