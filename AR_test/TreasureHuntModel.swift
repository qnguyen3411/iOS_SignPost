//
//  TreasureHuntModel.swift
//  AR_test
//
//  Created by Quang Nguyen on 9/13/18.
//  Copyright © 2018 Quang Nguyen. All rights reserved.
//

import UIKit
import MapKit


class TreasureHuntModel {
    
    static func getTreasureHuntsNearLocation(
        _ location: CLLocation,
        completionHandler: @escaping(
            _ data: Data?,
            _ response: URLResponse?,
            _ error: Error?) -> Void) {
        
        if let urlToReq = URL(string: "http://192.168.1.132:8000/treasurehunt") {
            // Create an NSMutableURLRequest using the url. This Mutable Request will allow us to modify the headers.
            var request = URLRequest(url: urlToReq)
            // Set the method to POST
            request.httpMethod = "POST"
            // Create some bodyData and attach it to the HTTPBody
            let bodyData = "latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)"
            request.httpBody = bodyData.data(using: .utf8)
            // Create the session
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
            task.resume()
        }
    }
    
    static func newTreasureHuntAtLocation(
        _ location: CLLocation,
        title: String,
        text: String,
        completionHandler: @escaping(
        _ data: Data?,
        _ response: URLResponse?,
        _ error: Error?) -> Void) {
        
        if let urlToReq = URL(string: "http://192.168.1.132:8000/treasurehunt/add") {
            // Create an NSMutableURLRequest using the url. This Mutable Request will allow us to modify the headers.
            var request = URLRequest(url: urlToReq)
            // Set the method to POST
            request.httpMethod = "POST"
            // Create some bodyData and attach it to the HTTPBody
            var bodyData = "latitude=\(location.coordinate.latitude)"
            bodyData += "&longitude=\(location.coordinate.longitude)"
            bodyData += "&title=\(title)&text=\(text)"
            print("BODYDATA: \(bodyData)")
            request.httpBody = bodyData.data(using: .utf8)
            // Create the session
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
            task.resume()
        }
    }
}

class ClueNodeModel {
    static func getClueNodesNearLocation(
        _ location: CLLocation,
        completionHandler: @escaping(
            _ data: Data?,
            _ response: URLResponse?,
            _ error: Error?) -> Void) {
        
        if let urlToReq = URL(string: "http://192.168.1.132:8000/cluenode") {
            // Create an NSMutableURLRequest using the url. This Mutable Request will allow us to modify the headers.
            var request = URLRequest(url: urlToReq)
            // Set the method to POST
            request.httpMethod = "POST"
            // Create some bodyData and attach it to the HTTPBody
            let bodyData = "latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)"
            request.httpBody = bodyData.data(using: .utf8)
            // Create the session
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
            task.resume()
        }
    }
    
    static func addNewClueNodeAtLocation(
        _ location: CLLocation,
        title: String,
        text: String,
        prevNodeId: String,
        completionHandler: @escaping(
            _ data: Data?,
            _ response: URLResponse?,
            _ error: Error?) -> Void) {
        
        if let urlToReq = URL(string: "http://192.168.1.132:8000/cluenode/add") {
            // Create an NSMutableURLRequest using the url. This Mutable Request will allow us to modify the headers.
            var request = URLRequest(url: urlToReq)
            // Set the method to POST
            request.httpMethod = "POST"
            // Create some bodyData and attach it to the HTTPBody
            var bodyData = "latitude=\(location.coordinate.latitude)"
            bodyData += "&longitude=\(location.coordinate.longitude)"
            bodyData += "&title=\(title)&text=\(text)&unique_id=\(prevNodeId)"
            request.httpBody = bodyData.data(using: .utf8)
            // Create the session
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
            task.resume()
        }
    }
    
    static func markClueAsStartingPoint(clueID: String) {
        if let urlToReq = URL(string: "http://192.168.1.132:8000/cluenode/mark"){
            var request = URLRequest(url: urlToReq)
            // Set the method to POST
            request.httpMethod = "POST"
            // Create some bodyData and attach it to the HTTPBody
            var bodyData = "unique_id=\(clueID)"
            request.httpBody = bodyData.data(using: .utf8)
            // Create the session
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest, completionHandler: {_,_,_ in })
            task.resume()
        }
        
    }

}



