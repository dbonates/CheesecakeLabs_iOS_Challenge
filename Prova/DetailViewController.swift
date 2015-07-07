//
//  DetailViewController.swift
//  Prova
//
//  Created by Daniel Bonates on 7/7/15.
//  Copyright (c) 2015 Daniel Bonates. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet var autdataLbl: UILabel!
    @IBOutlet weak var articleImg: UIImageView!
    @IBOutlet weak var contentTxt: UITextView!

    var article:Article? {
        didSet {
            updateView()
        }
    }
    
    var image:UIImage?
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.updateView()
        }
    }

    func updateView() {
        
        if let art:Article = self.article {
            if let title = self.titleLbl {
                self.titleLbl.hidden = false
                title.text = art.title
                title.sizeToFit()
                
            }
            if let authData = self.autdataLbl {
                self.autdataLbl.hidden = false
                authData.text = art.authors! + ", " + art.website!
                authData.sizeToFit()
            }
            if let content = self.contentTxt {
                self.contentTxt.hidden = false
                content.text = art.content!
                content.sizeToFit()
                content.scrollRangeToVisible(NSMakeRange(0, 0))
                
            }
            
            if let img = self.articleImg {
                self.articleImg.hidden = false
                if (self.image != nil) {
                    img.image = self.image
                } else {
                    img.image = UIImage(named: "ckl-logo.png")
                }
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLbl.text = "Choose one item from the list. You can use the menu button to open the list."
        self.autdataLbl.hidden = true
        self.contentTxt.hidden = true
        self.articleImg.hidden = true
        
        self.view.backgroundColor = bgColor

        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            
            var frame = self.articleImg.frame
            frame.size.height = 500
            self.articleImg.frame = frame
            self.titleLbl.font = UIFont(name: "American Typewriter", size: 28.0)
            self.autdataLbl.font = UIFont(name: "American Typewriter", size: 22.0)
            self.contentTxt.font = UIFont(name: "Helvetica", size: 22.0)
        }
        
        self.updateView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

