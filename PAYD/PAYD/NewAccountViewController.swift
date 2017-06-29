//
//  NewAccountViewController.swift
//  PAYD
//
//  The viewcontroller to create a new user and log in
//
//  Created by Jennifer Buur on 08-06-17.
//  Copyright © 2017 Jennifer Buur. All rights reserved.
//

import UIKit
import Firebase

class NewAccountViewController: UIViewController {

    // outlet to make new account
    @IBOutlet var firstnameTextField: UITextField!
    @IBOutlet var lastnameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    // initiate firebase reference
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        // get firebase reference
        ref = Database.database().reference()
        NotificationCenter.default.addObserver(self, selector: #selector(createAccount), name: NSNotification.Name(rawValue: "Email does not exist"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(alert), name: NSNotification.Name(rawValue: "Password incorrect"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // if notification password incorrect, because it is a new user, if email already exists user should be notified
    func alert(_notification: NSNotification) {
        Databasehelper.shared.alertUser(title: "Something went wrong!", message: "Email already exists", viewcontroller: self)
    }
    
    // if notification create account
    func createAccount(_notification: NSNotification) {
        // if email doesn't exist create new user
        Userinfo.email = (emailTextField.text!.replacingOccurrences(of: ".", with: ""))
        let newUser = ["firstname": self.firstnameTextField.text, "lastname": self.lastnameTextField.text, "mail": self.emailTextField.text, "password": self.passwordTextField.text]
        self.ref.child("users").child(Userinfo.email).setValue(newUser)
        performSegue(withIdentifier: "newAccountSegue", sender: nil)
    }
    
    // create account account from button
    @IBAction func createNewAccount(_ sender: Any) {
        // alert user if any field is empty
        if (firstnameTextField.text?.isEmpty)! || (lastnameTextField.text?.isEmpty)! || (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            Databasehelper.shared.alertUser(title: "Invalid input", message: "Please fill in all textfields", viewcontroller: self)
        }
        // check if email exists
        Databasehelper.shared.checkMail(email: emailTextField.text!, password: "")
    }
}
