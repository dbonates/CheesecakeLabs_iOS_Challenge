//
//  MasterViewController.swift
//  Prova
//
//  Created by Daniel Bonates on 7/7/15.
//  Copyright (c) 2015 Daniel Bonates. All rights reserved.
//

import UIKit
import Foundation

// Pod frameworks
import SwiftyJSON
import Alamofire
import AlamoImage

// a little extension for toogle masterviewcontroller when item is selected on iPad Vertical orientation
extension UISplitViewController {
    func toggleMasterView() {
        let barButtonItem = self.displayModeButtonItem()
        UIApplication.sharedApplication().sendAction(barButtonItem.action, to: barButtonItem.target, from: nil, forEvent: nil)
    }
}

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    
    let articlesLink = "http://daniels-macbook-pro.local:5757/data.json"
    var articles: [Article] = []
    
    // Using a cache for images
    var imageCache = [String:UIImage]()
    


    override func awakeFromNib() {
        super.awakeFromNib()
        
        // configuring the navbar for whole app
        UINavigationBar.appearance().barTintColor = redLightColor
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]

        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    // MARK: - Loaded!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // configure splitview for layouting purposes on universal app (iphone & ipad)
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
        
        //set the deafault tableview background
        self.tableView.backgroundColor = bgColor
        
        // start the app loading the articles
        loadArticles()
        
    }
    
    
    
    //  using Alamofire for network stuff
    func loadArticles() {
        
        Alamofire.request(.GET, articlesLink, parameters: nil)
            .responseJSON { (request, response, data, error) in
                
                var json = JSON(data!)
                
                let articlesArr = json.arrayValue
                
                self.setupArticlesArray(articlesArr)
                
                self.tableView.reloadData()
                
        }
        
    }
    
    
    
    // func that build the array
    func setupArticlesArray(arr:[JSON]) {
        
        for (var i = 0; i < arr.count; i++) {
            
            let title   : String = arr[i]["title"].stringValue
            let date    : String = arr[i]["date"].stringValue
            let authors : String = arr[i]["authors"].stringValue
            let image   : String = arr[i]["image"].stringValue
            let website : String = arr[i]["website"].stringValue
            let content : String = arr[i]["content"].stringValue
            
            var read : Bool = false
            
            
            self.articles.append(Article(_title: title, _dateStr: date, _authors: authors, _image: image, _website: website, _content: content, _readStatus:read))
        }
        
        
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if(segue.identifier == "showDetail") {
                if let indexPath = self.tableView.indexPathForSelectedRow() {
                    let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                    let idx = indexPath.row
                    let article = articles[idx]
                    controller.article = article
                    // send a cached version
                    controller.image = self.imageCache[article.image!]
                    
                    // set back buttons
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                    controller.navigationItem.leftItemsSupplementBackButton = true
                    
                }
            }
        }
    }

    // MARK: - Table View

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:ArticleTableViewCell! = tableView.dequeueReusableCellWithIdentifier("Cell") as! ArticleTableViewCell
        
        if(cell == nil) {
            cell = NSBundle.mainBundle().loadNibNamed("Cell", owner: self, options: nil)[0] as! ArticleTableViewCell
        }
        
        // configure cell
        
        cell.setupInfo(self.articles[indexPath.row])
        
        
        // placeholder
        cell.articleImageView.image = UIImage(named: "ckl-logo.png");
        
        
        let imgUrlStr:String! = self.articles[indexPath.row].image;
        
        if (imgUrlStr != nil) {
            
            /*
            Check for image on cache to avoid unecessary download
            */
            if let img = self.imageCache[imgUrlStr] {
                
                cell.articleImageView?.image = img
                
            }
            else
            {
                Alamofire.request(.GET, imgUrlStr)
                    .responseImage() { (request, _, image, error) in
                        if error == nil && image != nil {
                            cell.articleImageView.image = image
                            
                            //add image to cache
                            self.imageCache[imgUrlStr] = image
                        }
                }
                
            }
            
        }
        
        return cell;
    }

    
}
