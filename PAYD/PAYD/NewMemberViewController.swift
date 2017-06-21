//
//  NewMemberViewController.swift
//  PAYD
//
//  Created by Jennifer Buur on 08-06-17.
//  Copyright © 2017 Jennifer Buur. All rights reserved.
//

import UIKit
import Firebase

class NewMemberViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    var origRef: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        origRef = FIRDatabase.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addMember(_ sender: Any) {
        if (emailTextField.text?.isEmpty)! {
//            Databasehelper.shared.alertUser(title: "Invalid email", message: "Please fill in an email!")
        }
        if (nameTextField.text?.isEmpty)! {
//            Databasehelper.shared.alertUser(title: "Invalid name", message: "Please fill in a name!")
        }
        let email = (emailTextField.text?.replacingOccurrences(of: ".", with: ""))!
        if Databasehelper.shared.checkMail(email: emailTextField.text!) == false {
            // user bestaat nog niet
            origRef.child("users").child(email).setValue(["mail": emailTextField.text!])
            origRef.child("users").child(email).child("groups").setValue(["\(Userinfo.groupname)": Userinfo.groupkey])
            origRef.child("groups").child(Userinfo.groupkey).child("members").setValue(["\(email)": email])
            // LATER: nog mail reference
        } else {
            // user bestaat wel
            origRef.child("users").child(email).child("groups").updateChildValues(["\(Userinfo.groupname)": Userinfo.groupkey])
            origRef.child("groups").child(Userinfo.groupkey).child("members").updateChildValues(["\(email)": email])
        }
        nameTextField.text = ""
        emailTextField.text = ""
    }
}
