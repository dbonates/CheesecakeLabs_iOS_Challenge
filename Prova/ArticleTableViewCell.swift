//
//  ArticleTableViewCell.swift
//  Prova
//
//  Created by Daniel Bonates on 7/7/15.
//  Copyright (c) 2015 Daniel Bonates. All rights reserved.
//

import UIKit
import Alamofire

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var articleImageView: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var authorsLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.articleImageView.layer.cornerRadius = self.articleImageView.frame.size.width/2
        self.articleImageView.clipsToBounds = true
        self.articleImageView.backgroundColor = blueColor
        self.articleImageView.layer.borderWidth = 2.0
        self.articleImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
        
        self.backgroundColor = bgColor;
    }
    
    
    func setupInfo(article:Article) {
        
        self.titleLbl!.text = article.title
        self.authorsLbl!.text = article.authors! + ", " + article.dateStr!
        self.authorsLbl!.sizeToFit()
        
        if(article.readStatus == true) {
            configureRead()
        } else {
            configureNotRead()
        }
    }
    
    func configureRead() {
        self.accessoryType = UITableViewCellAccessoryType.Checkmark
        self.titleLbl.textColor = blueLightColor
        self.authorsLbl.textColor = blueLightColor
        self.articleImageView.image = convertImageToGrayScale(self.articleImageView.image!)
    }
    
    func configureNotRead() {
        self.accessoryType = UITableViewCellAccessoryType.None
        self.titleLbl.textColor = UIColor.whiteColor()
        self.authorsLbl.textColor = yellowColor
    }
    
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
