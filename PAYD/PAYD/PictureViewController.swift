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
    
    var origRef: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        origRef = FIRDatabase.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func openLibrary(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imagePicked.image = image
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func saveImage(_ sender: Any) {
        if (descriptionTextField.text?.isEmpty)! {
//            Databasehelper.shared.alertUser(title: "No description!", message: "Please fill in a description")
        } else {
            let imageData = UIImageJPEGRepresentation(imagePicked.image!, 0.6)
            let newPicture = ["image": imageData, "description": descriptionTextField.text!] as [String : Any]
            origRef.child("groups").child(Userinfo.groupkey).child("moments").setValue(newPicture)
        }
    }
    
}
