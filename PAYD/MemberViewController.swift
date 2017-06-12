//
//  MemberViewController.swift
//  PAYD
//
//  Created by Jennifer Buur on 08-06-17.
//  Copyright © 2017 Jennifer Buur. All rights reserved.
//

import UIKit
import Firebase

class MemberViewController: UIViewController {

    var groupname = String()
    var ref: FIRDatabaseReference!
    var members = [String]()
    var saldo = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return members.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: "memberCell") as! GroupTableViewCell
        newCell.memberNameLabel.text = members[indexPath.row]
        newCell.saldoLabel.text = saldo[indexPath.row]
        return newCell
    }
    
    // editing tableview
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let name = members[indexPath.row]
            ref.child(name).observe(.value, with: {snapshot in
                let snapshotValue = (snapshot as? FIRDataSnapshot)?.value as! NSDictionary
                if snapshotValue["saldo"] == 0 {
                    ref.child("\(name)/user").removeValue()
                    ref.child("\(name)/saldo").removeValue()
                } else {
                    // alert user that saldo is not 0
                }
            })
            [members, saldo] = Databasehelper.shared.refresh(ref: ref)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

//extension GroupViewController: UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        row = indexPath.row
//        origRef.child("groups").observe(.value, with: {snapshot in
//            for child in snapshot.children {
//                let snapshotValue = (child as? FIRDataSnapshot)?.value
//                    as! NSDictionary
//                if snapshotValue["name"] as? String == self.groups[self.row] {
//                    self.newRef = self.self.origRef.child("groups/\(child)")
//                }
//            }
//        })
//        performSegue(withIdentifier: "MemberView", sender: self)
//    }
//}

