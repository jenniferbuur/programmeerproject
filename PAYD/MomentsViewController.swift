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
    
    @IBOutlet var reactionTableView: UITableView!
    @IBOutlet var reactionTextField: UITextField!
    
    var origRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        self.reactionTableView.backgroundColor = UIColor.clear
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
        return Userinfo.description.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: "momentCell") as! MomentTableViewCell
        // nieuwe functie om reacties te laden
        newCell.backgroundColor = UIColor.clear
        return newCell
    }
}
