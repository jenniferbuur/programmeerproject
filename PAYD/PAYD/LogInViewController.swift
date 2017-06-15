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
//    var groups = [String]()
//    var email = String()
//    
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
        Userinfo.email = (emailTextField.text?.replacingOccurrences(of: ".", with: ""))!
        if Databasehelper.shared.checkMail(email: emailTextField.text!) != false {
            if Databasehelper.shared.logIn(ref: ref.child("users/\(Userinfo.email)"), password: passwordTextField.text!) != false {
                newRef = ref.child("users/\(Userinfo.email)")
                print("reached1")
                performSegue(withIdentifier: "Groupview", sender: self)
            } else {
                // Alert user password is incorrect
            }
        } else {
            // Alert user email is incorrect
        }
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "GroupView" {
//            let nav = segue.destination as! UINavigationController
//            let groupViewController = nav.topViewController as! GroupViewController
//            groupViewController.email = email
//            groupViewController.groups = groups
//        }
//    }

}

