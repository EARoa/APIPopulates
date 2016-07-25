//
//  PhotosTableViewController.swift
//  APIPopulate
//
//  Created by Efrain Ayllon on 7/25/16.
//  Copyright © 2016 Efrain Ayllon. All rights reserved.
//

import UIKit

class PhotosTableViewController: UITableViewController {
    
    var photos = [Photos]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateTheImages()

        
    }

    
    private func populateTheImages() {
        
        let theAPI = "http://jsonplaceholder.typicode.com/photos"
        
        guard let url = NSURL(string: theAPI) else {
            fatalError("Invalid URL")
        }
        
        let session = NSURLSession.sharedSession()
        
        
        session.dataTaskWithURL(url) { (data :NSData?, response :NSURLResponse?, error :NSError?) in
            
            guard let jsonResult = NSString(data: data!, encoding: NSUTF8StringEncoding) else {
                fatalError("Unable to format data")
            }
            
            let photosResult = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! [AnyObject]
            
            
            for item in photosResult {
                
                let photos = Photos()
                photos.title = item.valueForKey("title") as! String
                photos.thumbnailURL = item.valueForKey("thumbnailUrl") as! String
                
                self.photos.append(photos)
                
            }
            
            
            // loop ended I can refresh the tableview
            dispatch_async(dispatch_get_main_queue(), {
                // this is the main/ui thread
                self.tableView.reloadData()
                
            })
            
            
            
            }.resume()
        
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photos.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotosCell", forIndexPath: indexPath)

        let photos = self.photos[indexPath.row]
        
        guard let imageURL = NSURL(string: photos.thumbnailURL) else {
            fatalError("Invalid URL")
        }
        
        let imageData = NSData(contentsOfURL: imageURL)
        
        let image = UIImage(data: imageData!)
        
        cell.imageView?.image = image
        
        print(photos.thumbnailURL)
        
        cell.textLabel?.text = photos.title
        
        return cell
    }
}
