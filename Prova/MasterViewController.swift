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


import MZFormSheetPresentationController


// a little extension for toogle masterviewcontroller when item is selected on iPad Vertical orientation
extension UISplitViewController {
    func toggleMasterView() {
        let barButtonItem = self.displayModeButtonItem()
        UIApplication.sharedApplication().sendAction(barButtonItem.action, to: barButtonItem.target, from: nil, forEvent: nil)
    }
}

class MasterViewController: UITableViewController {
    
    // Sort menu view
    @IBOutlet weak var sortMenuView: UIView!

    var detailViewController: DetailViewController? = nil
    
    let articlesLink = "http://www.ckl.io/challenge/"
    var articles: [Article] = []
    
    // Using a cache for images
    var imageCache = [String:UIImage]()
    
    
    // persistent data system
    var readArticles = [String:Bool]()
    var dataFilePath: String?
    
    var condensedRowHeight : CGFloat = 100.0


    override func awakeFromNib() {
        super.awakeFromNib()
        
        // get rotation notification for layouting stuff if needed
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
        
    }
    
    // MARK: - Loaded!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configuring the navbar for whole app
        UINavigationBar.appearance().barTintColor = UIColor(red:1,  green:0.749,  blue:0.239, alpha:1)
        UINavigationBar.appearance().tintColor = blueColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : blueColor]
        
        UIButton.appearance().tintColor = yellowColor
        
        
        // the persistent system is simple and just track the status of items
        checkForHistory()
        
        // configure splitview for layouting purposes on universal app (iphone & ipad)
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
        
        
        // sort menu & setup
        self.sortMenuView.backgroundColor = blueColor
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"ic_menu"), style: UIBarButtonItemStyle.Plain, target: self, action: "toogleSortMenu")
        MZFormSheetPresentationController.appearance().shouldApplyBackgroundBlurEffect = true // for blue fx
        // sort notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sortNotificationSent:", name: sortNotificationKey, object: nil)
        
        // reset readStatus notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setAllItemsAsUnread", name: unreadAllNotificationKey, object: nil)
        
        //set the default tableview design
        self.tableView.backgroundColor = bgColor
        self.tableView.tintColor = yellowColor
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone && UIApplication.sharedApplication().statusBarOrientation.isLandscape   {
            self.tableView.rowHeight = self.condensedRowHeight;
        }
        
        
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
            
            if(readArticles[title] == true) {
                read = true
            } else {
                readArticles[title] = false; //force it to be present, if not
            }
            
            var article = Article(_title: title, _dateStr: date, _authors: authors, _image: image, _website: website, _content: content, _readStatus:read)
            self.articles.append(article)
        }
        
        
    }
    
    // MARK: - persistent data stuff
    
    func checkForHistory() {
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        dataFilePath = docsDir.stringByAppendingPathComponent("data.archive")
        
        if filemgr.fileExistsAtPath(dataFilePath!) {
            readArticles =  NSKeyedUnarchiver.unarchiveObjectWithFile(dataFilePath!) as! [String:Bool]
        }
    }
    
    func saveReadArticles() {
        NSKeyedArchiver.archiveRootObject(readArticles, toFile: dataFilePath!)
    }
    
    
    // MARK: - Sorting functions & related
    
    func sortNotificationSent(notification:NSNotification) {
        
        let userInfo:Dictionary<String,String!> = notification.userInfo as! Dictionary<String,String!>
        sortArticles(userInfo["sortKey"]!)
    }
    
    func toogleSortMenu() {
        
        let sortViewController = self.storyboard!.instantiateViewControllerWithIdentifier("sortViewController") as! UIViewController
        let formSheetController = MZFormSheetPresentationController(contentViewController: sortViewController)
        formSheetController.blurEffectStyle = UIBlurEffectStyle.Light
        formSheetController.shouldDismissOnBackgroundViewTap = true
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.StyleSlideAndBounceFromRight
        
        formSheetController.contentViewSize = CGSizeMake(320, 320)
        
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }
    
    func sortArticles(sortKey: String) {
        
        switch sortKey {
            case "date":
                self.articles = self.articles.sorted({$0.date!.timeIntervalSinceNow > $1.date!.timeIntervalSinceNow})
            case "title":
                self.articles = self.articles.sorted({$0.title < $1.title})
            case "author":
                self.articles = self.articles.sorted({$0.authors < $1.authors})
            case "website":
                self.articles = self.articles.sorted({$0.website < $1.website})
            default:
                self.articles = self.articles.sorted({$0.date!.timeIntervalSinceNow > $1.date!.timeIntervalSinceNow})
        }
        
        self.tableView.reloadData()

    }
    
    
    // MARK: - Reset all item to unread status
    func setAllItemsAsUnread() {
        
        for (var i=0; i<self.articles.count;i++) {
            
            let item = self.articles[i]
            
            self.readArticles[item.title!] = false
            
            var art = Article(_title: item.title!, _dateStr: item.dateStr!, _authors: item.authors!, _image: item.image!, _website: item.website!, _content: item.content!, _readStatus: false)
            
            self.articles[i] = art
            
        }
//
        saveReadArticles()
        self.tableView.reloadData()
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
                
                if(self.readArticles[articles[indexPath.row].title!] == true) {
                    cell.articleImageView?.image = convertImageToGrayScale(img)
                } else {
                    cell.articleImageView?.image = img
                }

                
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

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.articles[indexPath.row].readStatus = true
        
        let cell : ArticleTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! ArticleTableViewCell
        
        cell.configureRead()
        
        
        // on iPad at vertical orientation it closes the list
        self.splitViewController!.toggleMasterView()
        
        // save the read list
        readArticles[self.articles[indexPath.row].title!] = true;
        
        saveReadArticles()
        
        
    }
    
    
    // a little animation
    // just for the pull request ;P
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }

    
    
    // MARK: - orientation fixes
    
    func manageRowHeight() {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone && UIApplication.sharedApplication().statusBarOrientation.isLandscape  {
            self.tableView.rowHeight = self.condensedRowHeight;
        } else {
            self.tableView.rowHeight = 138.0;
            
        }
    }
    
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        manageRowHeight()
        self.tableView.reloadData()
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

