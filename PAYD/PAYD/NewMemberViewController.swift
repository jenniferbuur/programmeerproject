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
    
    var ref: FIRDatabaseReference!
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
        if Databasehelper.shared.checkMail(ref: origRef.child("users/\(emailTextField.text)"), email: emailTextField.text) == false {
            // user bestaat nog niet
            origRef.child("user/\(emailTextField.text)").setValue(["mail": emailTextField.text])
            origRef.child("user/\(emailTextField.text)/groups").setValue(["name": ref])
            ref.child(nameTextField.text).setValue(["user": ref.child("users/\(emailTextField.text)"), "saldo": 0])
            // LATER: nog mail reference
        } else {
            // user bestaat wel
            origRef.child("user/\(emailTextField.text)/groups").setValue(["name": ref])
            ref.child(nameTextField.text).setValue(["user": ref.child("users/\(emailTextField.text)"), "saldo": 0])
        }
        nameTextField.text = ""
        emailTextField.text == ""
    }
}
