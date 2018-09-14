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
        resetARSession()
        currClueIndex = 0
        updateClueFoundLabel()
        if let tabBarController = self.tabBarController as? TabBarController {
            if let mapVC = tabBarController.mapViewController {
                mapVC.scanForClues()
            }
        }
        if !clues.isEmpty {
            displayClue(clues[currClueIndex])
        }
    }
    
    @IBAction func nextClueButtonPressed(_ sender: UIButton) {
        if !clues.isEmpty {
            currClueIndex += 1
            if currClueIndex > clues.count - 1 {
                currClueIndex = 0
            }
            updateClueFoundLabel()
            displayClue(clues[currClueIndex])
        }
    }
    
    @IBAction func markButtonPressed(_ sender: UIButton) {
        if !clues.isEmpty {
            ClueNodeModel.markClueAsStartingPoint(clueID: clues[currClueIndex].uniqueID)
        }
        resetARSession()
        currClueIndex = 0
        if let tabBarController = self.tabBarController as? TabBarController {
            if let mapVC = tabBarController.mapViewController {
                mapVC.scanForClues()
            }
        }
        updateClueFoundLabel()
        displayClue(clues[currClueIndex])

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
    
    func displayClue(_ clue: Clue) {
        let scene = SCNScene()
        let sign1 = SignPost(title: clue.title,
                             uniqueID: clue.uniqueID,
                             text: clue.text)
        sign1.position = SCNVector3(0,0,-0.3)
        scene.rootNode.addChildNode(sign1)
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    func updateClueFoundLabel() {
        if clues.count == 0 {
            cluesFoundLabel.text = "Viewing clue: \(currClueIndex)/\(clues.count)"
        } else {
            cluesFoundLabel.text = "Viewing clue: \(currClueIndex + 1)/\(clues.count)"
        }
    }
    
    func resetARSession() {

        sceneView.session.pause()
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode() }
        setupARSession()
    }
    
    func setupARSession() {
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration, options: [ARSession.RunOptions.resetTracking, ARSession.RunOptions.removeExistingAnchors])
        
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
