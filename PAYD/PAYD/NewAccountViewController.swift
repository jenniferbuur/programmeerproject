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
    var groups = [String]()
    var email = String()
    
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
        email = (emailTextField.text?.replacingOccurrences(of: ".", with: ""))!
        groups = Databasehelper.shared.checkGroups(ref: ref.child("users/\(email)"))
        var value = NSDictionary()
        if Databasehelper.shared.checkMail(ref: ref.child("users"), email:emailTextField.text!) == false {
            // make new user with no groups
            let newUser = ["firstname": firstnameTextField.text, "lastname": lastnameTextField.text, "mail": emailTextField.text, "password": passwordTextField.text]
            ref.child("users/\(email)").setValue(newUser)
            Userinfo.email = email
        } else {
            ref.child("users/\(email)/password").observe(.value, with: {snapshot in
                value = (snapshot as FIRDataSnapshot).value as! NSDictionary
            })
            if ((value["password"] as? String)?.isEmpty)! {
                // Alert user that email is already in use
            } else {
                // Make new user with already existing groups
                let newUser = ["firstname": firstnameTextField.text, "lastname": lastnameTextField.text, "password": passwordTextField.text]
                ref.child("users/\(email)").setValue(newUser)
                Userinfo.email = email
                Userinfo.groups = groups
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination as! UINavigationController
        let groupViewController = nav.topViewController as! GroupViewController
        groupViewController.email = self.email
        groupViewController.groups = self.groups
    }
}
