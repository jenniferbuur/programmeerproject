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
    
    var origRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        origRef = Database.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addMember(_ sender: Any) {
        if (emailTextField.text?.isEmpty)! {
            Databasehelper.shared.alertUser(title: "Invalid email", message: "Please fill in an email!", viewcontroller: self)
        }
        if (nameTextField.text?.isEmpty)! {
            Databasehelper.shared.alertUser(title: "Invalid name", message: "Please fill in a name!", viewcontroller: self)
        }
        let email = (emailTextField.text?.replacingOccurrences(of: ".", with: ""))!
        Databasehelper.shared.checkMail(email: emailTextField.text!) { (exist) -> () in
            if exist == true {
                // user bestaat wel
                self.origRef.child("users").child(email).child("groups").updateChildValues(["\(Userinfo.groupname)": Userinfo.groupkey])
                self.origRef.child("groups").child(Userinfo.groupkey).child("members").updateChildValues(["\(email)": email])
            } else {
                // user bestaat nog niet
                self.origRef.child("users").child(email).setValue(["mail": self.emailTextField.text!])
                self.origRef.child("users").child(email).child("groups").setValue(["\(Userinfo.groupname)": Userinfo.groupkey])
                self.origRef.child("groups").child(Userinfo.groupkey).child("members").updateChildValues(["\(email)": email])
                // LATER: nog mail reference
            }
        }
        nameTextField.text = ""
        emailTextField.text = ""
    }
}
