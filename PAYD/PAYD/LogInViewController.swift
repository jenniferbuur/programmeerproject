//
//  ViewController.swift
//  PAYD
//
//  Created by Jennifer Buur on 08-06-17.
//  Copyright © 2017 Jennifer Buur. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    var ref: FIRDatabaseReference!
    var newRef: FIRDatabaseReference!
    var groups = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInButton(_ sender: Any) {
        if Databasehelper.shared.checkMail(ref: ref.child("users"), email: emailTextField.text!) != false {
            if Databasehelper.shared.logIn(ref: ref.child("users/\(emailTextField.text)"), password: passwordTextField.text!) != false {
                newRef = ref.child("users/\(emailTextField.text)")
                groups = Databasehelper.shared.checkGroups(ref: newRef)
                performSegue(withIdentifier: "GroupView", sender: self)
            } else {
                // Alert user password is incorrect
            }
        } else {
            // Alert user email is incorrect
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GroupView" {
            let groupViewController = segue.destination as! GroupViewController
            groupViewController.ref = self.newRef
            groupViewController.groups = self.groups
        }
    }

}

