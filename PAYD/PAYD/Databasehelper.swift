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
    var storage = Storage.storage().reference()
    
    func logIn(ref: DatabaseReference, password: String, completionHandler: @escaping((_ exist: Bool) -> Void)) {
        ref.observeSingleEvent(of: .value, with: {snapshot in
            let snapshotValue = snapshot.value as! NSDictionary
            if snapshotValue["password"] as? String == password {
                Userinfo.username = (snapshotValue["firstname"] as? String)!
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
    
    func setGroups(email: String, table: UITableView) {
        Userinfo.groups.removeAll()
        origRef.child("groups").observeSingleEvent(of: .value, with: {snapshot in
            for child in snapshot.children {
                let key = (child as! DataSnapshot).key
                self.origRef.child("groups").child(key).child("members").observeSingleEvent(of: .value, with: {snap in
                    for member in snap.children {
                        let memberValue = (member as! DataSnapshot).value as! String
                        if memberValue == email {
                            let snapshotValue = (child as! DataSnapshot).value as! NSDictionary
                            self.origRef.child("users").child(Userinfo.email).child("groups").child("\(snapshotValue["name"]!)").setValue(key)
                            Userinfo.groups.append(snapshotValue["name"] as! String)
                            table.reloadData()
                        }
                    }
                })
            }
        })
    }
    
    func checkGroups(email: String, table: UITableView) {
        Userinfo.groups.removeAll()
        origRef.child("users").child(email).child("groups").observeSingleEvent(of: .value, with: {snapshot in
            if !snapshot.exists() {
                return
            } else {
                for child in snapshot.children {
                    let snap = (child as! DataSnapshot)
                    Userinfo.groups.append(snap.key)
                }
                table.reloadData()
            }
        })
    }
    
    func removeUserinfo() {
        Userinfo.email.removeAll()
        Userinfo.groups.removeAll()
        Userinfo.groupkey.removeAll()
        Userinfo.groupname.removeAll()
        Userinfo.downloadURLs.removeAll()
        Userinfo.picturekey = 0
        Userinfo.description.removeAll()
    }
    
    func removeGroup(viewcontroller: UIViewController) {
        origRef.child("groups").child(Userinfo.groupkey).child("members").observeSingleEvent(of: .value, with: {snapshot in
            if snapshot.childrenCount == 1 {
                self.origRef.child("groups").child(Userinfo.groupkey).child("moments").observeSingleEvent(of: .value, with: { snapshot in
                    for picture in 1 ..< snapshot.childrenCount+1 {
                        self.storage.child(Userinfo.groupkey).child("\(picture)").delete { error in
                            if error != nil {
                                print(error as Any)
                                Databasehelper.shared.alertUser(title: "Uh-Ooh", message: "Wasn't able to remove the whole group", viewcontroller: viewcontroller)
                            }
                        }
                    }
                })
                self.origRef.child("groups").child(Userinfo.groupkey).removeValue()
            }
        })
    }
    
    func getGroupkey(completionHandler: @escaping ((_ exist: Bool) -> Void)) {
        print("groupkey")
        origRef.child("users").child(Userinfo.email).child("groups").observeSingleEvent(of: .value, with: {snapshot in
            for child in snapshot.children {
                if (child as! DataSnapshot).key == Userinfo.groupname {
                    Userinfo.groupkey = (child as! DataSnapshot).value as! String
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
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
    
    func getChat(table: UITableView) {
        origRef.child("groups").child(Userinfo.groupkey).child("chat").observeSingleEvent(of: .value, with: {snapshot in
            for child in snapshot.children {
                let snapshotValue = (child as! DataSnapshot).value as! NSDictionary
                Userinfo.chats.append((snapshotValue["message"] as? String)!)
                Userinfo.names.append((snapshotValue["name"] as? String)!)
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
