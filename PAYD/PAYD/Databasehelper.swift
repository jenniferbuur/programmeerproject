//
//  Databasehelper.swift
//  PAYD
//
//  This class has functions that are needed in de viewcontrollers
//
//  Created by Jennifer Buur on 12-06-17.
//  Copyright © 2017 Jennifer Buur. All rights reserved.
//

import Foundation
import Firebase

class Databasehelper {
    
    static let shared = Databasehelper()
    
    // references to Firebase Database and Storage
    var origRef = Database.database().reference()
    var storage = Storage.storage().reference()
    
    // function that checks password
    func logIn(password: String) {
        
        // search database for all current userinfo
        origRef.child("users").child(Userinfo.email).observeSingleEvent(of: .value, with: {snapshot in
            let snapshotValue = snapshot.value as! NSDictionary
            // check password
            if snapshotValue["password"] as! String == password {
                // send notification to make sure user goes to next view
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Logged In"), object: nil)
                return
            } else {
                // return alert if password is incorrect
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Password incorrect"), object: nil)
            }
        })
    }
    
    // check if the user email is correct/exists
    func checkMail(email: String, password: String) {
        
        // search the database for all users
        origRef.child("users").observeSingleEvent(of: .value, with: {snapshot in
            for child in snapshot.children {
                let snapshotValue = (child as! DataSnapshot).value as! NSDictionary
                // remember email user in app if exists
                if snapshotValue["mail"] as! String == email {
                    Userinfo.email = (email.replacingOccurrences(of: ".", with: ""))
                    Databasehelper.shared.logIn(password: password)
                }
            }
            if Userinfo.email.isEmpty {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Email does not exist"), object: nil)
            }
        })
    }
    
    
    // search for all groups which the current user is part of
    func setGroups(email: String, table: UITableView) {
        // make sure in app user groups is empty
        Userinfo.groups.removeAll()
        // search all groups for all members
        origRef.child("groups").observeSingleEvent(of: .value, with: {snapshot in
            for child in snapshot.children {
                let key = (child as! DataSnapshot).key
                self.origRef.child("groups").child(key).child("members").observeSingleEvent(of: .value, with: {snap in
                    // check for every member in a group if it is equal to current user
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
    
    // if user logs out all userinfo is removed from in app database
    func removeUserinfo() {
        Userinfo.email.removeAll()
        Userinfo.groups.removeAll()
        Userinfo.groupkey.removeAll()
        Userinfo.downloadURLs.removeAll()
        Userinfo.picturekey = 0
        Userinfo.description.removeAll()
    }
    
    // removes groups if user intends to
    func removeGroup(viewcontroller: UIViewController) {
        // check is group still has members
        origRef.child("groups").child(Userinfo.groupkey).child("members").observeSingleEvent(of: .value, with: {snapshot in
            // if only one member left (current user) remove whole group
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
                // finally remove to groupkey because group doesnt exist anymore
                self.origRef.child("groups").child(Userinfo.groupkey).removeValue()
            }
        })
    }
    
    // if clicked on group get groupkey
    func getGroupkey(groupname: String) {
        
        // search database for userinfo and its groups and remember groupkey if names are equal
        origRef.child("users").child(Userinfo.email).child("groups").observeSingleEvent(of: .value, with: {snapshot in
            for child in snapshot.children {
                if (child as! DataSnapshot).key == groupname {
                    Userinfo.groupkey = (child as! DataSnapshot).value as! String
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GroupkeyLoaded"), object: nil)
                }
            }
        })

    }
    
    // gets all downloadurls and descriptions of a group
    func refreshData(group: String, table: UICollectionView) {
        // remove all in app data to make sure no double items
        Userinfo.downloadURLs.removeAll()
        Userinfo.description.removeAll()
        // search in current group for moments, which are photos with descriptions
        origRef.child("groups").child(group).child("moments").observeSingleEvent(of: .value, with: {snapshot in
            // find all moments and add them
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
    
    // function to alert a user if something is wrong
    func alertUser(title: String, message: String, viewcontroller: UIViewController) {
        
        // initiate alertcontroller with OK action
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
        // show alertcontroller
        viewcontroller.present(alertController, animated: true, completion: nil)
        return
    }

}
