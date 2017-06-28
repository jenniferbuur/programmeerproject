//
//  PicturesCollectionViewController.swift
//  PAYD
//
//  This Viewcontroller is the first viewcontroller of the tab bar
//  It shows all pictures of a group and has a button to add one
//
//  Created by Jennifer Buur on 23-06-17.
//  Copyright © 2017 Jennifer Buur. All rights reserved.
//

import UIKit
import Firebase

class PicturesCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    // outlets
    @IBOutlet var picturesView: UICollectionView!
    
    // references
    var origRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        self.picturesView.backgroundColor = UIColor.clear
        Userinfo.description.removeAll()
        Userinfo.downloadURLs.removeAll()
        // set references
        origRef = Database.database().reference()
        // handle notifications
        NotificationCenter.default.addObserver(self, selector: #selector(loadMoments), name: NSNotification.Name(rawValue: "GroupKeyLoaded"), object: nil)
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 100,height: 100)
        
        
        self.picturesView.setCollectionViewLayout(layout, animated: true)
        
        picturesView.delegate = self
        picturesView.dataSource = self
        // Do any additional setup after loading the view.
    }

    // everytime to view appear reload data
    override func viewDidAppear(_ animated: Bool) {
        if !Userinfo.groupkey.isEmpty {
            Userinfo.description.removeAll()
            Userinfo.downloadURLs.removeAll()
            Databasehelper.shared.refreshData(group: Userinfo.groupkey, table: picturesView)
        }
    }
    
    override func didReceiveMemoryWarning() { 
        super.didReceiveMemoryWarning()
    }
    
    // loadmoments when groupkey loaded
    func loadMoments(_notification: NSNotification) {
        Userinfo.description.removeAll()
        Userinfo.downloadURLs.removeAll()
        Databasehelper.shared.refreshData(group: Userinfo.groupkey, table: picturesView)
    }

    
    // MARK: collectionView
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return Userinfo.description.count
    }
    
    // set all collectionview items
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let newCell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as! PictureCollectionViewCell
        newCell.pictureView.image = nil
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
