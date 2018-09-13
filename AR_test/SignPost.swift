//
//  SignPost.swift
//  AR_test
//
//  Created by Quang Nguyen on 9/13/18.
//  Copyright © 2018 Quang Nguyen. All rights reserved.
//

import UIKit
import SceneKit

class SignPost: SCNNode {
//    var frame[String:SCNNode] = [:]
    var text = ""
    private let positioningNode = SCNNode()
    
    init(_ string: String) {
        
        super.init()
        let text = SCNText(string: string, extrusionDepth: 0.1)
        text.font = UIFont.systemFont(ofSize: 1.0)
        text.flatness = 0.01
        text.isWrapped = true
        text.firstMaterial?.diffuse.contents = UIColor.white
        
        let fontSize = Float(0.04)
        self.scale = SCNVector3(fontSize, fontSize, fontSize)
        self.position = SCNVector3(0,0,-0.3)
        
//        let lFrame = SCNNode()
//        let plane = SCNPlane(width:0.01, height:0.1)
//        plane.firstMaterial?.diffuse.contents = UIColor.white
//
//        lFrame.geometry = plane
//        lFrame.position = SCNVector3(-2,0,-0)
//
//        self.addChildNode(lFrame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        print("ERROR")
    }
    
    func addText(_ string: String) -> SCNNode {
        let text = SCNText(string: string, extrusionDepth: 0.1)
        text.font = UIFont.systemFont(ofSize: 1.0)
        text.flatness = 0.01
        text.isWrapped = true
        text.firstMaterial?.diffuse.contents = UIColor.white
        
        let textNode = SCNNode(geometry: text)
        
        let fontSize = Float(0.04)
        textNode.scale = SCNVector3(fontSize, fontSize, fontSize)
        textNode.position = SCNVector3(0,0,-0)
        
        return textNode
    }
}
