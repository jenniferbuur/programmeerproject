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
    
    var origRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Userinfo.description.removeAll()
        Userinfo.downloadURLs.removeAll()
        origRef = Database.database().reference()
        NotificationCenter.default.addObserver(self, selector: #selector(loadMoments), name: NSNotification.Name(rawValue: "GroupKeyLoaded"), object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMoments(_notification: NSNotification) {
        Databasehelper.shared.refreshData(group: Userinfo.groupkey, table: momentsTableView)
    }
    
}

//MARK: tableview
extension MomentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Userinfo.description.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: "momentCell") as! MomentTableViewCell
        newCell.descriptionView.text = Userinfo.description[indexPath.row]
        let storageRef = Storage.storage().reference(forURL: Userinfo.downloadURLs[indexPath.row])
        storageRef.getData(maxSize: 1 * 4096 * 4096) { (data, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                newCell.momentView.contentMode = .scaleAspectFit
                newCell.momentView.image = UIImage(data: data!)
            }
        }
        return newCell
    }
}
