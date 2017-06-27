//
//  ChatViewController.swift
//  PAYD
//
//  Created by Jennifer Buur on 27-06-17.
//  Copyright © 2017 Jennifer Buur. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet var chatTableView: UITableView!
    @IBOutlet var messageTextField: UITextField!
    
    var ref: DatabaseReference!
    var keyboardUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        ref = Database.database().reference()
        Databasehelper.shared.getChat(table: chatTableView)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name(rawValue: "hideKeyboard"), object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(_notification: NSNotification) {
        keyboardUp = true
        if let keyboardSize = (_notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    func keyboardWillHide(_notification: NSNotification) {
        if keyboardUp {
            keyboardUp = false
            if let keyboardSize = (_notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        let message = messageTextField.text!
        messageTextField.text = ""
        ref.child("groups").child(Userinfo.groupkey).child("chat").child("\(Userinfo.chats.count)").setValue(["message": message, "name": Userinfo.username])
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideKeyboard"), object: nil)
        Databasehelper.shared.getChat(table: chatTableView)
    }
}

//MARK: tableview
extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Userinfo.chats.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: "chatCell") as! ChatTableViewCell
//        newCell.groupNameLabel.text = Userinfo.groups[indexPath.row]
//        newCell.backgroundColor = UIColor.clear
        return newCell
    }
    
    // editing tableview
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
