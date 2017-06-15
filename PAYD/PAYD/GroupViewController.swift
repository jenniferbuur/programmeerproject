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
    
    var origRef: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        origRef = FIRDatabase.database().reference()
        groupTableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addGroup(_ sender: Any) {
        let key = "\(newgroupTextField.text!)\(Userinfo.email)"
        origRef.child("users").child(Userinfo.email).child("groups").child(newgroupTextField.text!).setValue(key)
        origRef.child("groups").child(key).setValue(["name": newgroupTextField.text!])
        origRef.child("groups").child(key).child("members").setValue(["\(Userinfo.email)": Userinfo.email])
        Userinfo.groups.append(newgroupTextField.text!)
        groupTableView.reloadData()
        newgroupTextField.text = ""
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
        return newCell
    }
    
    // editing tableview
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            origRef.child("users").child(Userinfo.email).child("groups").child(Userinfo.groups[indexPath.row]).removeValue()
            origRef.child("groups").observe(.value, with: {snapshot in
                for child in snapshot.children {
                    let snapshotValue = (child as? FIRDataSnapshot)?.value as! NSDictionary
                    if snapshotValue["name"] as? String == Userinfo.groups[indexPath.row] {
                        self.origRef.child("groups").child((child as AnyObject).key).removeValue()
                    }
                }
            })
            Userinfo.groups = Databasehelper.shared.checkGroups(email: Userinfo.email)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
    
//extension GroupViewController: UITableViewDelegate {
//        
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        Userinfo.groupkey = "\(Userinfo.groups[indexPath.row])\(Userinfo.email)"
//        Userinfo.moments = Databasehelper.shared.refreshData(group: Userinfo.groups[indexPath.row])
//        Userinfo.groupname = Userinfo.groups[indexPath.row]
//        performSegue(withIdentifier: "MemberView", sender: self)
//    }
//}

