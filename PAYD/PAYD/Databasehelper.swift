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
    
    var origRef = Database.database().reference()
    
    func logIn(ref: DatabaseReference, password: String, completionHandler: @escaping((_ exist: Bool) -> Void)) {
        ref.observeSingleEvent(of: .value, with: {snapshot in
            let snapshotValue = snapshot.value as! NSDictionary
            if snapshotValue["password"] as? String == password {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        })
    }
    
    func checkMail(email: String, completionHandler: @escaping ((_ exist: Bool) -> Void)) {
        origRef.child("users").observeSingleEvent(of: .value, with: {snapshot in
            for child in snapshot.children {
                let snapshotValue = (child as! DataSnapshot).value as! NSDictionary
                if snapshotValue["mail"] as? String == email {
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
        })
    }
    
    func checkGroups(email: String, table: UITableView) {
        Userinfo.groups.removeAll()
        origRef.child("users").child(email).child("groups").observeSingleEvent(of: .value, with: {snapshot in
            if !snapshot.exists() {
                return
            }
            for child in snapshot.children.allObjects {
                let snap = child as! DataSnapshot
                Userinfo.groups.append(snap.key)
            }
            table.reloadData()
        })
    }
    
    func refreshData(group: String, table: UICollectionView) {
        Userinfo.downloadURLs.removeAll()
        Userinfo.description.removeAll()
        origRef.child("groups").child(group).child("moments").observeSingleEvent(of: .value, with: {snapshot in
            if !snapshot.exists() {
                return
            }
            for child in snapshot.children {
                let snapshotValue = (child as? DataSnapshot)?.value as! NSDictionary
                Userinfo.description.append((snapshotValue["description"] as? String)!)
                Userinfo.downloadURLs.append((snapshotValue["imageURL"] as? String)!)
                }
            table.reloadData()
        })
    }
    
    func alertUser(title: String, message: String, viewcontroller: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
        viewcontroller.present(alertController, animated: true, completion: nil)
        return
    }
}
