//
//  MemberViewController.swift
//  PAYD
//
//  Created by Jennifer Buur on 08-06-17.
//  Copyright © 2017 Jennifer Buur. All rights reserved.
//

import UIKit
import Firebase

class MomentsViewController: UIViewController {

    @IBOutlet var momentsTableView: UITableView!
    
    var origRef: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        origRef = FIRDatabase.database().reference()
        Databasehelper.shared.refreshData(group: Userinfo.groupkey, table: momentsTableView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

//MARK: tableview
extension MomentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Userinfo.moments.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: "momentCell") as! MomentTableViewCell
        newCell.momentLabel.text = Userinfo.moments[indexPath.row]
        return newCell
    }
    
    // editing tableview
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            origRef.child("groups").child(Userinfo.groupkey).child("moments").child("\(Userinfo.moments[indexPath.row])\(Userinfo.groupkey)").removeValue()
            Userinfo.moments = Databasehelper.shared.refreshData(group: Userinfo.groupkey)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
