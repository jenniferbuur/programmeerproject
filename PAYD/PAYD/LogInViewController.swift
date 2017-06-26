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
    
    var ref: DatabaseReference!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        ref = Database.database().reference()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInButton(_ sender: Any) {
        if (emailTextField.text?.isEmpty)! {
            Databasehelper.shared.alertUser(title: "Invalid email", message: "Please fill in a email", viewcontroller: self)
        }
        Userinfo.email = (emailTextField.text?.replacingOccurrences(of: ".", with: ""))!
        Databasehelper.shared.checkMail(email: emailTextField.text!) { (exist) -> () in
            if exist == true {
                Databasehelper.shared.logIn(ref: self.ref.child("users/\(Userinfo.email)"), password: self.passwordTextField.text!) { (exist) -> () in
                    if exist == false {
                        // Alert user password is incorrect
                        Databasehelper.shared.alertUser(title: "Something went wrong!", message: "Invalid password", viewcontroller: self)
                    } else {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadGroups"), object: nil)
                    }
                }
            } else {
                // Alert user email is incorrect
                Databasehelper.shared.alertUser(title: "Something went wrong!", message: "Invalid email", viewcontroller: self)
            }
        }
    }
    
    @IBAction func unwindToLogIn(segue: UIStoryboardSegue) {}
}

