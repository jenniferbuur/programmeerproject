//
//  PicturesCollectionViewController.swift
//  PAYD
//
//  Created by Jennifer Buur on 23-06-17.
//  Copyright © 2017 Jennifer Buur. All rights reserved.
//

import UIKit
import Firebase

class PicturesCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var picturesView: UICollectionView!
    
    var origRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        self.picturesView.backgroundColor = UIColor.clear
        Userinfo.description.removeAll()
        Userinfo.downloadURLs.removeAll()
        origRef = Database.database().reference()
        NotificationCenter.default.addObserver(self, selector: #selector(loadMoments), name: NSNotification.Name(rawValue: "GroupKeyLoaded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadMoments), name: NSNotification.Name(rawValue: "BackToPictures"), object: nil)
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 100,height: 100)
        
        
        self.picturesView.setCollectionViewLayout(layout, animated: true)
        
        picturesView.delegate = self
        picturesView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMoments(_notification: NSNotification) {
        Databasehelper.shared.refreshData(group: Userinfo.groupkey, table: picturesView)
    }

    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return Userinfo.description.count
    }
    
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let newCell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as! PictureCollectionViewCell
        
        let storageRef = Storage.storage().reference(forURL: Userinfo.downloadURLs[indexPath.row])
        storageRef.getData(maxSize: 1 * 4096 * 4096) { (data, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                newCell.pictureView.contentMode = .scaleAspectFill
                newCell.pictureView.image = UIImage(data: data!)
            }
        }
        newCell.backgroundColor = UIColor.clear
        return newCell
    }
    
    
    internal func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Userinfo.picturekey = indexPath.row
    }
}
