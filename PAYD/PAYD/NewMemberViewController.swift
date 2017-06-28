//
//  NewMemberViewController.swift
//  PAYD
//
//  This ViewController allows the current user to add a member to a group
//
//  Created by Jennifer Buur on 08-06-17.
//  Copyright © 2017 Jennifer Buur. All rights reserved.
//

import UIKit
import Firebase

class NewMemberViewController: UIViewController {

    // outlets
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    // reference
    var origRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        // set reference
        origRef = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // add a member when button clicked
    @IBAction func addMember(_ sender: Any) {
        // alert user if textfield is empty
        if (emailTextField.text?.isEmpty)! {
            Databasehelper.shared.alertUser(title: "Invalid email", message: "Please fill in an email!", viewcontroller: self)
        }
        if (nameTextField.text?.isEmpty)! {
            Databasehelper.shared.alertUser(title: "Invalid name", message: "Please fill in a name!", viewcontroller: self)
        }
        // add new member to group based on email
        let email = (emailTextField.text?.replacingOccurrences(of: ".", with: ""))!
        self.origRef.child("groups").child(Userinfo.groupkey).child("members").updateChildValues(["\(email)": email])
        nameTextField.text = ""
        emailTextField.text = ""
    }
}
