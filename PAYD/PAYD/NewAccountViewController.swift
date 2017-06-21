//
//  NewAccountViewController.swift
//  PAYD
//
//  Created by Jennifer Buur on 08-06-17.
//  Copyright © 2017 Jennifer Buur. All rights reserved.
//

import UIKit
import Firebase

class NewAccountViewController: UIViewController {

    @IBOutlet var firstnameTextField: UITextField!
    @IBOutlet var lastnameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createNewAccount(_ sender: Any) {
        Userinfo.email = (emailTextField.text?.replacingOccurrences(of: ".", with: ""))!
        if Databasehelper.shared.checkMail(email:emailTextField.text!) == false {
            // make new user with no groups
            let newUser = ["firstname": firstnameTextField.text, "lastname": lastnameTextField.text, "mail": emailTextField.text, "password": passwordTextField.text]
            ref.child("users").child(Userinfo.email).setValue(newUser)
        } else {
            ref.child("users").child(Userinfo.email).child("password").observe(.value, with: {snapshot in
                if snapshot.exists() {
                    // Alert user that email is already in use
//                    Databasehelper.shared.alertUser(title: "Invalid email", message: "Email is already in use!")
                } else {
                // Make new user with already existing groups
                    let newUser = ["firstname": self.firstnameTextField.text, "lastname": self.lastnameTextField.text, "password": self.passwordTextField.text]
                    self.ref.child("users").child(Userinfo.email).updateChildValues(newUser)
                }
            })
        }
    }
}
