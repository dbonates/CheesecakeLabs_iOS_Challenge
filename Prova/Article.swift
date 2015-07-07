//
//  Article.swift
//  Prova
//
//  Created by Daniel Bonates on 7/7/15.
//  Copyright (c) 2015 Daniel Bonates. All rights reserved.
//

import Foundation


// should handle title, date, author, website, content and image
// also a status for read

struct Article {
    var title:String?
    var dateStr:String?
    var date:NSDate?
    var authors:String?
    var image:String?
    var website:String?
    var content:String?
    
    var readStatus:Bool?
    
    
    init(_title:String, _dateStr:String, _authors:String, _image:String, _website:String, _content:String, _readStatus:Bool) {
        title = _title
        dateStr = _dateStr
        authors = _authors
        image = _image
        website = _website
        content = _content
        
        readStatus = _readStatus
    }
    
}