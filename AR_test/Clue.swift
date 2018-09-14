//
//  File.swift
//  AR_test
//
//  Created by Quang Nguyen on 9/14/18.
//  Copyright © 2018 Quang Nguyen. All rights reserved.
//

import Foundation
class Clue {
    var title: String
    var uniqueID: String
    var text: String
    
    init(title:String, uniqueID:String, text:String) {
        self.title = title
        self.uniqueID = uniqueID
        self.text = text
    }
}
