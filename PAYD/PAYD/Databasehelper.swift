//
//  Databasehelper.swift
//  PAYD
//
//  Created by Jennifer Buur on 12-06-17.
//  Copyright © 2017 Jennifer Buur. All rights reserved.
//

import Foundation
import Firebase

class Databasehelper {
    
    static let shared = Databasehelper()
    
    func logIn(ref: FIRDatabaseReference, password: String) -> Bool {
        ref.observe(.value, with: {snapshot in
            let snapshotValue = snapshot.value as! NSDictionary
            if snapshotValue["password"] as? String == password {
                return
            }
        })
        return false
    }
    
    func checkMail(ref: FIRDatabaseReference, email: String) -> Bool {
        ref.observe(.value, with: {snapshot in
            for child in snapshot.children {
                let snapshotValue = (child as! FIRDataSnapshot).value as! NSDictionary
                if snapshotValue["mail"] as? String == email {
                    return
                }
            }
        })
        return false
    }
    
    func checkGroups(ref: FIRDatabaseReference) -> [String] {
        var groups = [String]()
        ref.child("groups").observe(.value, with: {snapshot in
            let snapshotValue = snapshot.value as! NSDictionary
            for key in snapshotValue {
                let newRef = snapshotValue[key] as? FIRDatabaseReference
                newRef?.observe(.value, with: {snap in
                    let snapValue = snap.value as! NSDictionary
                    groups.append((snapValue["name"] as? String)!)
                })
            }
        })
        return groups
    }
    
    func refreshData(ref: FIRDatabaseReference) -> ([String], [String]) {
        var saldo = [String]()
        var members = [String]()
        var newRef: FIRDatabaseReference!
        ref.child("members").observe(.value, with: {snapshot in
            for child in snapshot.children {
                let snapshotValue = (child as? FIRDataSnapshot)?.value as! NSDictionary
                saldo.append((snapshotValue["saldo"] as? String)!)
                newRef = snapshotValue["user"] as? FIRDatabaseReference
                newRef?.observe(.value, with: {snap in
                    let snapValue = snap.value as! NSDictionary
                    members.append((snapValue["firstname"] as? String)!)
                })
            }
        })
        return (members, saldo)
    }
    
}
