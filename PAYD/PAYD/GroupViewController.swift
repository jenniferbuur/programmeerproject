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
    
    var email = Userinfo.shared.getEmail()
    var groups = Userinfo.shared.getGroups()
    var origRef: FIRDatabaseReference!
    var newRef: FIRDatabaseReference!
    var row = Int()
    var members = [String]()
    var saldo = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        origRef = FIRDatabase.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addGroup(_ sender: Any) {
        let key = "\(newgroupTextField.text!)\(email)"
        origRef.child("users").child(email).child("groups").child(newgroupTextField.text!).setValue(key)
        origRef.child("groups").child(key).setValue(["name": newgroupTextField.text!])
        origRef.child("groups").child(key).child(email).setValue(["user": email, "saldo": 0])
        Userinfo.groups.append(newgroupTextField.text!)
        groupTableView.reloadData()
        newgroupTextField.text = ""
    }
}

//MARK: tableview
extension GroupViewController: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: "groupCell") as! GroupTableViewCell
        newCell.groupNameLabel.text = groups[indexPath.row]
        return newCell
    }
    
    // editing tableview
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            origRef.child("\(email)/groups/\(groups[indexPath.row])").removeValue()
            origRef.child("groups").observe(.value, with: {snapshot in
                for child in snapshot.children {
                    let snapshotValue = (child as? FIRDataSnapshot)?.value as! NSDictionary
                    if snapshotValue["name"] as? String == self.groups[indexPath.row] {
                        self.origRef.child("groups/\(child)").removeValue()
                    }
                }
            })
            groups = Databasehelper.shared.checkGroups(ref: origRef.child("\(email)/groups"))
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
    
extension GroupViewController: UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        row = indexPath.row
        origRef.child("groups").observe(.value, with: {snapshot in
            for child in snapshot.children {
                let snapshotValue = (child as? FIRDataSnapshot)?.value
                    as! NSDictionary
                if snapshotValue["name"] as? String == self.groups[self.row] {
                    self.newRef = self.self.origRef.child("groups/\(child)")
                }
            }
        })
        (members, saldo) = Databasehelper.shared.refreshData(ref: newRef)
        performSegue(withIdentifier: "MemberView", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MemberView" {
            let memberViewController = segue.destination as! MemberViewController
            let newmemberViewController = segue.destination as! NewMemberViewController
            memberViewController.groupname = self.groups[row]
            memberViewController.ref = self.newRef
            memberViewController.members = self.members
            memberViewController.saldo = self.saldo
            newmemberViewController.ref = self.newRef
        }
    }
}

