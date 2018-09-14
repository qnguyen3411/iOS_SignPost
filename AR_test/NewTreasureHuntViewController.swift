//
//  NewTreasureHuntViewController.swift
//  AR_test
//
//  Created by Quang Nguyen on 9/13/18.
//  Copyright © 2018 Quang Nguyen. All rights reserved.
//

import UIKit


class NewTreasureHuntViewController: UIViewController {
    
    
    @IBOutlet weak var feedBackLabel: UILabel!
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var textField: UITextView!
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        if let title = titleField.text, let text = textField.text {
            if let tabBarController = self.tabBarController as? TabBarController {
                if let mapVC = tabBarController.mapViewController {
                    mapVC.addNewTreasureHunt(withTitle: title, text: text)
                }
                titleField.text = ""
                textField.text = ""
            }
        } else {
            feedBackLabel.text = "Fields can't be empty!"
        }
        
        feedBackLabel.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tabBarController = self.tabBarController as? TabBarController {
            tabBarController.newTreasureHuntController = self
        }
        
        feedBackLabel.isHidden = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func displaySuccessFeedback(withUniqueID id:String) {
        feedBackLabel.text = "First clue created with ID: \(id).\nWrite it down, you'll need it to make the next clue!"

    }


}
