//
//  SelectedPictureViewController.swift
//  PAYD
//
//  Show full picture when clicked on collection view
//
//  Created by Jennifer Buur on 23-06-17.
//  Copyright © 2017 Jennifer Buur. All rights reserved.
//

import UIKit
import Firebase

class SelectedPictureViewController: UIViewController {

    // outlets
    @IBOutlet var selectedPictureView: UIImageView!
    @IBOutlet var selectedDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        // set picture and description
        Storage.storage().reference(withPath: "\(Userinfo.groupkey)/\(Userinfo.picturekey+1)").getData(maxSize: 1 * 4096 * 4096) {
            (data, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                self.selectedPictureView.contentMode = .scaleAspectFit
                self.selectedPictureView.image = UIImage(data: data!)
                self.selectedDescription.text = Userinfo.description[Userinfo.picturekey]
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
