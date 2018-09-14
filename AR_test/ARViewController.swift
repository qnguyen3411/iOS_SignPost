//
//  ViewController.swift
//  AR_test
//
//  Created by Quang Nguyen on 9/12/18.
//  Copyright © 2018 Quang Nguyen. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var cluesFoundLabel: UILabel!
    
    var clues:[Clue] = []
    var currClueIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tabBarController = self.tabBarController as? TabBarController {
            tabBarController.arViewController = self
            if let mapVC = tabBarController.mapViewController {
                mapVC.scanForClues()
            }
            
        }
        
        
        
        updateClueFoundLabel()
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        if let tabBarController = self.tabBarController as? TabBarController {
            if let mapVC = tabBarController.mapViewController {
                mapVC.scanForClues()
            }
        }
    }
    
    @IBAction func nextClueButtonPressed(_ sender: UIButton) {
        if currClueIndex >= clues.count - 1 {
            currClueIndex = 0
        } else {
            currClueIndex += 1
        }
    }
    
    
    
    func didFindNewClues(_ clues: [Clue]) {
        self.clues = clues
        updateClueFoundLabel()
        if let clue = clues.first {
            let scene = SCNScene()
            let sign1 = SignPost(title: clue.title,
                                 uniqueID: clue.uniqueID,
                                 text: clue.text)
            sign1.position = SCNVector3(0,0,-0.3)
            scene.rootNode.addChildNode(sign1)
            // Set the scene to the view
            sceneView.scene = scene
        }
    }
    
    func updateClueFoundLabel() {
        if clues.count == 0 {
            cluesFoundLabel.text = "Viewing clue: \(currClueIndex)/\(clues.count)"
        } else {
            cluesFoundLabel.text = "Viewing clue: \(currClueIndex + 1)/\(clues.count)"
        }
        
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
