//
//  GroupViewController.swift
//  PAYD
//
//  Created by Jennifer Buur on 08-06-17.
//  Copyright © 2017 Jennifer Buur. All rights reserved.
//

import UIKit
import Firebase

class GroupViewController: UIViewController {

    @IBOutlet var newgroupTextField: UITextField!
    @IBOutlet var groupTableView: UITableView!
    
    var origRef: DatabaseReference!
    var groups = [String]()
    var storage: StorageReference!
    var keyboardUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        self.groupTableView.backgroundColor = UIColor.clear
        Userinfo.groupkey.removeAll()
        origRef = Database.database().reference()
        storage = Storage.storage().reference()
        Databasehelper.shared.setGroups(email: Userinfo.email, table: groupTableView)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Userinfo.description.removeAll()
        Userinfo.downloadURLs.removeAll()
    }
    
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
    
    @IBAction func addGroup(_ sender: Any) {
        if (newgroupTextField.text?.isEmpty)! {
            Databasehelper.shared.alertUser(title: "Invalid name", message: "Please fill in a groupname!", viewcontroller: self)
        } else {
            let key = "\(newgroupTextField.text!)\(Userinfo.email)"
            origRef.child("users").child(Userinfo.email).child("groups").child(newgroupTextField.text!).setValue(key)
            origRef.child("groups").child(key).setValue(["name": newgroupTextField.text!])
            origRef.child("groups").child(key).child("members").setValue(["\(Userinfo.email)": Userinfo.email])
            Userinfo.groups.append(newgroupTextField.text!)
        }
        groupTableView.reloadData()
        newgroupTextField.text = ""
    }
    
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
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            Userinfo.groupname = Userinfo.groups[indexPath.row]
            Databasehelper.shared.getGroupkey() { (exist) -> () in
                if exist {
                    self.origRef.child("users").child(Userinfo.email).child("groups").child(Userinfo.groups[indexPath.row]).removeValue()
                    Userinfo.groups.remove(at: indexPath.row)
                    Databasehelper.shared.removeGroup(viewcontroller: self)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                } else {
//                    Databasehelper.shared.alertUser(title: "Uh-Ooh", message: "Wasn't able to remove group!", viewcontroller: self)
                }
            }
        }
    }
}

extension GroupViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Userinfo.groupname = Userinfo.groups[indexPath.row]
        Databasehelper.shared.getGroupkey() { (exist) -> () in
            if !exist {
//                Databasehelper.shared.alertUser(title: "Uh-Ooh", message: "Wasn't able to call group!", viewcontroller: self)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GroupKeyLoaded"), object: nil)
            }
        }
    }
}
