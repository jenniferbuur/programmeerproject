//
//  pictureViewController.swift
//  PAYD
//
//  Created by Jennifer Buur on 15-06-17.
//  Copyright © 2017 Jennifer Buur. All rights reserved.
//

import UIKit
import Firebase

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imagePicked: UIImageView!
    @IBOutlet var descriptionTextField: UITextField!
    
    var origRef: DatabaseReference!
    var imagePicker: UIImagePickerController!
    var storageRef: StorageReference!
    var keyboardUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        origRef = Database.database().reference()
        storageRef = Storage.storage().reference()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (self.isMovingToParentViewController) {
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BackToPictures"), object: nil)
        }
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
            if let keyboardSize = (_notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    @IBAction func openCamera(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func openLibrary(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("not available")
        }
    }
    
    @IBAction func saveImage(_ sender: Any) {
        if (descriptionTextField.text?.isEmpty)! {
            Databasehelper.shared.alertUser(title: "No description!", message: "Please fill in a description", viewcontroller: self)
        } else {
            let description = descriptionTextField.text!
            let imageOrientationFixed = imagePicked.image!.fixOrientation()
            let imageData = UIImagePNGRepresentation(imageOrientationFixed)
            storageRef.child(Userinfo.groupkey).child("\(Userinfo.description.count+1)").putData(imageData!, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
                DispatchQueue.main.async {
                    let imageInfo = ["imageURL": metadata?.downloadURL()?.absoluteString, "description": description, "key": Userinfo.description.count+1] as [String : Any]
                    self.origRef.child("groups").child(Userinfo.groupkey).child("moments").child("\(Userinfo.description.count+1)").setValue(imageInfo)
                }
            }
        }
        descriptionTextField.text = ""
        imagePicked.image = nil
    }
    
    //MARK: Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePicked.contentMode = .scaleAspectFit
        imagePicked.image = chosenImage //4
        dismiss(animated: true, completion: nil) //5
    }
}

extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage;
    }
}

