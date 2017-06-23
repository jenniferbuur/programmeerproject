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
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createNewAccount(_ sender: Any) {
        if (firstnameTextField.text?.isEmpty)! || (lastnameTextField.text?.isEmpty)! || (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            Databasehelper.shared.alertUser(title: "Invalid input", message: "Please fill in all textfields", viewcontroller: self)
        }
        Userinfo.email = (emailTextField.text?.replacingOccurrences(of: ".", with: ""))!
        Databasehelper.shared.checkMail(email:emailTextField.text!) { (exist) -> () in
            if exist == true {
                self.ref.child("users").child(Userinfo.email).child("password").observe(.value, with: {snapshot in
                    if snapshot.exists() {
                        // Alert user that email is already in use
                        Databasehelper.shared.alertUser(title: "Invalid email", message: "Email is already in use!", viewcontroller: self)
                    } else {
                        // Make new user with already existing groups
                        self.ref.child("users").child(Userinfo.email).child("firstname").setValue(self.firstnameTextField.text)
                        self.ref.child("users").child(Userinfo.email).child("lastname").setValue(self.lastnameTextField.text)
                        self.ref.child("users").child(Userinfo.email).child("password").setValue(self.passwordTextField.text)
                    }
                })
            } else {
                // make new user with no groups
                let newUser = ["firstname": self.firstnameTextField.text, "lastname": self.lastnameTextField.text, "mail": self.emailTextField.text, "password": self.passwordTextField.text]
                self.ref.child("users").child(Userinfo.email).setValue(newUser)
            }
        }
    }
}
