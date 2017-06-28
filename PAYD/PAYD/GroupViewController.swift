//
//  GroupViewController.swift
//  PAYD
//
//  This Viewcontroller shows all groups of the current user
//  and allows the current user to add a new group 
//  There is also a log out button
//
//  Created by Jennifer Buur on 08-06-17.
//  Copyright © 2017 Jennifer Buur. All rights reserved.
//

import UIKit
import Firebase

class GroupViewController: UIViewController {

    // outlets from viewcontroller
    @IBOutlet var newgroupTextField: UITextField!
    @IBOutlet var groupTableView: UITableView!
    
    // initiate references
    var origRef: DatabaseReference!
    var storage: StorageReference!
    var keyboardUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        self.groupTableView.backgroundColor = UIColor.clear
        Userinfo.groupkey.removeAll()
        // set references
        origRef = Database.database().reference()
        storage = Storage.storage().reference()
        // set groups for tableview
        Databasehelper.shared.setGroups(email: Userinfo.email, table: groupTableView)
        // handle notifications for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Userinfo.description.removeAll()
        Userinfo.downloadURLs.removeAll()
        Userinfo.groupkey.removeAll()
    }
    
    // handle keyboard
    func keyboardWillShow(_notification: NSNotification) {
        keyboardUp = true
        if let keyboardSize = (_notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    func keyboardWillHide(_notification: NSNotification) {
        if keyboardUp {
            keyboardUp = false
            if let keyboardSize = (_notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    // add a new group
    @IBAction func addGroup(_ sender: Any) {
        
        // check if textfield is not empty
        if (newgroupTextField.text?.isEmpty)! {
            Databasehelper.shared.alertUser(title: "Invalid name", message: "Please fill in a groupname!", viewcontroller: self)
        } else {
            // add new group
            let key = "\(newgroupTextField.text!)\(Userinfo.email)"
            origRef.child("users").child(Userinfo.email).child("groups").child(newgroupTextField.text!).setValue(key)
            origRef.child("groups").child(key).setValue(["name": newgroupTextField.text!])
            origRef.child("groups").child(key).child("members").setValue(["\(Userinfo.email)": Userinfo.email])
            Userinfo.groups.append(newgroupTextField.text!)
        }
        // set view to normal
        groupTableView.reloadData()
        newgroupTextField.text = ""
    }
    
    // log out
    @IBAction func logOut(_ sender: Any) {
        Databasehelper.shared.removeUserinfo()
        self.performSegue(withIdentifier: "unwindToLogIn", sender: self)
    }
}

//MARK: tableview
extension GroupViewController: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Userinfo.groups.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: "groupCell") as! GroupTableViewCell
        newCell.groupNameLabel.text = Userinfo.groups[indexPath.row]
        newCell.backgroundColor = UIColor.clear
        return newCell
    }
    
    // editing tableview
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // delete group
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            Userinfo.groupkey.removeAll()
            Userinfo.groupname = Userinfo.groups[indexPath.row]
            Databasehelper.shared.getGroupkey()
            if !Userinfo.groupkey.isEmpty {
                self.origRef.child("users").child(Userinfo.email).child("groups").child(Userinfo.groups[indexPath.row]).removeValue()
                Userinfo.groups.remove(at: indexPath.row)
                Databasehelper.shared.removeGroup(viewcontroller: self)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                Databasehelper.shared.alertUser(title: "Uh-Ooh", message: "Wasn't able to remove group!", viewcontroller: self)
            }
        }
    }
}

extension GroupViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Userinfo.groupname = Userinfo.groups[indexPath.row]
        Databasehelper.shared.getGroupkey()
    }
}
