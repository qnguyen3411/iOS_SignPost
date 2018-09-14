//
//  NewTreasureHuntViewController.swift
//  AR_test
//
//  Created by Quang Nguyen on 9/13/18.
//  Copyright © 2018 Quang Nguyen. All rights reserved.
//

import UIKit


class NewTreasureHuntViewController: UIViewController {
    
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var textField: UITextView!
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        if let title = titleField.text, let text = textField.text {
            if let tabBarController = self.tabBarController as? TabBarController {
                if let mapVC = tabBarController.mapViewController {
                    mapVC.addNewTreasureHunt(withTitle: title, text: text)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tabBarController = self.tabBarController as? TabBarController {
            tabBarController.newTreasureHuntController = self
        }
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
//        view.addGestureRecognizer(tap)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
//    func dismissKeyboard() {
//        //Causes the view (or one of its embedded text fields) to resign the first responder status.
//        view.endEditing(true)
//    }

}
