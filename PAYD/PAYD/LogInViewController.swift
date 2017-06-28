//
//  ViewController.swift
//  PAYD
//
//  The viewcontroller to log in an user
//
//  Created by Jennifer Buur on 08-06-17.
//  Copyright © 2017 Jennifer Buur. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    // outlets to log in
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
        // handle notifications
        NotificationCenter.default.addObserver(self, selector: #selector(logIn), name: NSNotification.Name(rawValue: "Logged In"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(emailIncorrect), name: NSNotification.Name(rawValue: "Email does not exist"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // if notification to log in perform segue
    func logIn(_notification: NSNotification) {
        emailTextField.text = ""
        passwordTextField.text = ""
        performSegue(withIdentifier: "logInSegue", sender: self)
    }
    
    // if notification alert user
    func emailIncorrect(_notification: NSNotification) {
        Databasehelper.shared.alertUser(title: "Uh-Ooh", message: "Email is not correct", viewcontroller: self)
    }
    
    // log in action from button
    @IBAction func logInButton(_ sender: Any) {
        
        // if any textfield are empty alert usesr
        if (emailTextField.text?.isEmpty)! {
            Databasehelper.shared.alertUser(title: "Invalid email", message: "Please fill in a email", viewcontroller: self)
        }
        if (passwordTextField.text?.isEmpty)! {
            Databasehelper.shared.alertUser(title: "Invalid password", message: "Please fill in a password", viewcontroller: self)
        }
        // check if email is in database and later check the password
        Databasehelper.shared.checkMail(email: emailTextField.text!, password: passwordTextField.text!, vc: self)
    }
    
    // segue necessary to log out
    @IBAction func unwindToLogIn(segue: UIStoryboardSegue) {}
}

