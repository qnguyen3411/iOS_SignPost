//
//  SignPost.swift
//  AR_test
//
//  Created by Quang Nguyen on 9/13/18.
//  Copyright © 2018 Quang Nguyen. All rights reserved.
//

import UIKit
import SceneKit


extension String {
    
    func insert(string:String,ind:Int) -> String {
        return  String(self.prefix(ind)) + string + String(self.suffix(self.count - ind))
    }
    
    func formatted() -> String {
        var formattedString = self
        if formattedString.count > 140 {
            formattedString = String(formattedString.prefix(140))
        }
        var numEmptyLines = 5
        for index in 0..<formattedString.count {
            if index % 30 == 0 && index != 0 {
                numEmptyLines -= 1
                formattedString = formattedString.insert(string: "\n", ind: index)
            }
        }
        
        return formattedString + String(repeating: "\n", count: numEmptyLines)
    }
}

class SignPost: SCNNode {
//    var frame[String:SCNNode] = [:]
    var text = ""
    private let positioningNode = SCNNode()
    
    init(_ string: String) {
        
        super.init()
        let text = SCNText(string: string.formatted(), extrusionDepth: 0.1)
        text.font = UIFont.systemFont(ofSize: 1.0)
        text.flatness = 0.01
        text.firstMaterial?.diffuse.contents = UIColor.green
        
        let fontSize = Float(0.04)
        self.geometry = text
        self.scale = SCNVector3(fontSize, fontSize, fontSize)
        self.position = SCNVector3(0,0,-0.3)
        
        let frame = addFrame()
        frame.position = SCNVector3(0,0,0)
        self.addChildNode(frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        print("ERROR")
    }
    
//    func addText(_ string: String) -> SCNNode {
//        let text = SCNText(string: string, extrusionDepth: 0.1)
//        text.font = UIFont.systemFont(ofSize: 1.0)
//        text.flatness = 0.01
//        text.isWrapped = true
//        text.firstMaterial?.diffuse.contents = UIColor.white
//
//        let textNode = SCNNode(geometry: text)
//
//        let fontSize = Float(0.04)
//        textNode.scale = SCNVector3(fontSize, fontSize, fontSize)
//        textNode.position = SCNVector3(0,0,-0)
//
//        return textNode
//    }
//
    
    func addFrame() -> SCNNode {
        let frame = SCNNode()
        let lFrame = SCNNode()
        var lBox = SCNBox(width: 0.1, height: 6, length: 0.1, chamferRadius: 0)
        lBox.firstMaterial?.diffuse.contents = UIColor.green
        lFrame.geometry = lBox
        lFrame.position = SCNVector3(-1,3.2,0)
        
        let rFrame = SCNNode()
        var rBox = SCNBox(width: 0.1, height: 6, length: 0.1, chamferRadius: 0)
        rBox.firstMaterial?.diffuse.contents = UIColor.green
        rFrame.geometry = rBox
        rFrame.position = SCNVector3(18,3.2,0)
        
        let bFrame = SCNNode()
        var bBox = SCNBox(width: 19, height: 0.1, length: 0.1, chamferRadius: 0)
        bBox.firstMaterial?.diffuse.contents = UIColor.green
        bFrame.geometry = bBox
        bFrame.position = SCNVector3(8.5,0.25,0)
        
        let tFrame = SCNNode()
        var tBox = SCNBox(width: 19, height: 0.1, length: 0.1, chamferRadius: 0)
        tBox.firstMaterial?.diffuse.contents = UIColor.green
        tFrame.geometry = tBox
        tFrame.position = SCNVector3(8.5,6.2,0)
        
        frame.addChildNode(lFrame)
        frame.addChildNode(rFrame)
        frame.addChildNode(bFrame)
        frame.addChildNode(tFrame)
        
        return frame
    }
}
