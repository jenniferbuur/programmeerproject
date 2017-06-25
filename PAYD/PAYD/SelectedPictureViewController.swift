//
//  SelectedPictureViewController.swift
//  PAYD
//
//  Created by Jennifer Buur on 23-06-17.
//  Copyright © 2017 Jennifer Buur. All rights reserved.
//

import UIKit
import Firebase

class SelectedPictureViewController: UIViewController {

    @IBOutlet var selectedPictureView: UIImageView!
    @IBOutlet var selectedDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
