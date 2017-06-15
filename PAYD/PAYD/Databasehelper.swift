//
//  Databasehelper.swift
//  PAYD
//
//  f119ee9e8cb7bd36673765aff59b68a6
//
//  Created by Jennifer Buur on 12-06-17.
//  Copyright © 2017 Jennifer Buur. All rights reserved.
//

import Foundation
import Firebase

class Databasehelper {
    
    static let shared = Databasehelper()
    
    var origRef = FIRDatabase.database().reference()
    
    func logIn(ref: FIRDatabaseReference, password: String) -> Bool {
        ref.observe(.value, with: {snapshot in
            let snapshotValue = snapshot.value as! NSDictionary
            if snapshotValue["password"] as? String == password {
                return
            }
        })
        return false
    }
    
    func checkMail(email: String) -> Bool {
        origRef.child("users").observe(.value, with: {snapshot in
            for child in snapshot.children {
                let snapshotValue = (child as! FIRDataSnapshot).value as! NSDictionary
                if snapshotValue["mail"] as? String == email {
                    return
                }
            }
        })
        return false
    }
    
    func checkGroups(email: String) -> [String] {
        var groups = [String]()
        origRef.child("users").child(email).child("groups").observe(.value, with: {snapshot in
            if !snapshot.exists() {
                return
            }
            let snapshotValue = snapshot.value as! NSDictionary
            for child in snapshotValue {
                let key = snapshotValue[child] as? String
                self.origRef.child("groups").child(key!).observe(.value, with: {snap in
                    let snapValue = snap.value as! NSDictionary
                    groups.append((snapValue["name"] as? String)!)
                })
            }
        })
        return groups
    }
    
    func refreshData(group: String) -> [String] {
        var moments = [String]()
        origRef.child("groups").child(group).child("moments").observe(.value, with: {snapshot in
            if !snapshot.exists() {
                return
            }
            for child in snapshot.children {
                let snapshotValue = (child as? FIRDataSnapshot)?.value as! NSDictionary
                moments.append((snapshotValue["name"] as? String)!)
            }
        })
        return moments
    }
}
