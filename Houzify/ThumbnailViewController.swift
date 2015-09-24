//
//  ThumblineViewController.swift
//  Houzify
//
//  Created by Swagat Kumar Bisoyi on 9/23/15.
//  Copyright (c) 2015 Swagat Kumar Bisoyi. All rights reserved.
//

import UIKit

class ThumbnailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    var arrunescapedUrl = NSMutableArray()
    var arrvisibleUrl = NSMutableArray()
    
    var totalPicDetails = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDummyData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell : ThumblineCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ThumblineCollectionViewCell
        
//        cell.imgThumbline.image = UIImage(named: "photo\(indexPath.row+1)")
        cell.imgThumbline.image = self.arrunescapedUrl[indexPath.row] as? UIImage

        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrunescapedUrl.count
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        
        
        var vc : FullScreenViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FullScreenViewController") as! FullScreenViewController
        vc.image = UIImage(named: "photo\(indexPath.row+1)")!
        vc.imageArray = self.arrunescapedUrl
        vc.indexPassed = indexPath.row+1
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    func addDummyData() {
        
        RestApiManager.sharedInstance.getRandomUser { (json: JSON) in
            
            
            let results = json["items"]
            
            
            for (index: String, subJson: JSON) in results
            {
                
                let feed = FlickrFeed()
                feed.title = subJson["title"].object as! String
                feed.media = subJson["media"]["m"].object as? String
                var picUrl: String = String(feed.media!)
                let exactImageUrl = NSURL(string: picUrl)
                let data = NSData(contentsOfURL: exactImageUrl!)
                var imageStored = UIImage(data: data!)
                self.arrunescapedUrl.addObject(imageStored!)
            }
            

            dispatch_async(dispatch_get_main_queue(),{
                collectionView?.reloadData()
            })

            
            self.collectionView?.reloadData()
            
        }
    }
    
    

}

