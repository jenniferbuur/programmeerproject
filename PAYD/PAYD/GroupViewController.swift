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

    var ref: FIRDatabaseReference!
    var groups = [String]()
    var origRef: FIRDatabaseReference!
    var newRef: FIRDatabaseReference!
    var row = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        origRef = FIRDatabase.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            ref.child("groups/\(groups[indexPath.row])").removeValue()
            origRef.child("groups").observe(.value, with: {snapshot in
                for child in snapshot.children {
                    let snapshotValue = (child as? FIRDataSnapshot)?.value as! NSDictionary
                    if snapshotValue["name"] as? String == self.groups[indexPath.row] {
                        self.origRef.child("groups/\(child)").removeValue()
                    }
                }
            })
            groups = Databasehelper.shared.checkGroups(ref: ref.child("groups"))
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
        performSegue(withIdentifier: "MemberView", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MemberView" {
            let memberViewController = segue.destination as! MemberViewController
            memberViewController.groupname = self.groups[row]
            memberViewController.ref = self.newRef
        }
    }
}

