//
//  SortMenuViewController.swift
//  Prova
//
//  Created by Daniel Bonates on 7/8/15.
//  Copyright (c) 2015 Daniel Bonates. All rights reserved.
//

import UIKit

class SortMenuViewController: UIViewController {

    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var titleBtn: UIButton!
    @IBOutlet weak var authorBtn: UIButton!
    @IBOutlet weak var websiteBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func postSortNotification(sender: AnyObject) {
        
        var sortKey = ""
        
        if(sender as! NSObject == self.titleBtn) {
            sortKey = "title"
        }
        else if(sender as! NSObject == self.websiteBtn) {
            sortKey = "website"
        }
        else if(sender as! NSObject == self.authorBtn) {
            sortKey = "author"
        }
        else if(sender as! NSObject == self.dateBtn) {
            sortKey = "date"
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(sortNotificationKey, object: self, userInfo: ["sortKey":sortKey])
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    @IBAction func postUnreadAllNotification(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(unreadAllNotificationKey, object: self)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
