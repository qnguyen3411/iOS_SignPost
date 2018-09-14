//
//  FormViewController.swift
//  AR_test
//
//  Created by Quang Nguyen on 9/13/18.
//  Copyright © 2018 Quang Nguyen. All rights reserved.
//

import UIKit

class NewClueViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var prevIDField: UITextField!
    
    @IBOutlet weak var textField: UITextView!
    
    @IBOutlet weak var feedBackLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tabBarController = self.tabBarController as? TabBarController {
            tabBarController.newClueViewController = self
        }
        feedBackLabel.isHidden = true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        if let title = titleField.text, let text = textField.text, let prevID = prevIDField.text {
            if let tabBarController = self.tabBarController as? TabBarController {
                if let mapVC = tabBarController.mapViewController {
                    mapVC.addNewNode(withTitle: title, text: text, prevID: prevID)
                }
                titleField.text = ""
                textField.text = ""
            }
        } else {
            feedBackLabel.text = "Fields can't be empty!"
        }
        feedBackLabel.isHidden = false
    }
    
    func displaySuccessFeedback(withUniqueID id:String) {
        feedBackLabel.text = "New clue created with ID: \(id).\nWrite it down, you'll need it to make the next clue!"
    }
    

}
