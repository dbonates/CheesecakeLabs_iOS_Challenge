//
//  Lib.swift
//  Prova
//
//  Created by Daniel Bonates on 7/7/15.
//  Copyright (c) 2015 Daniel Bonates. All rights reserved.
//

import Foundation
import UIKit

// color pallete
let bgColor = UIColor(red:0.075,  green:0.478,  blue:0.584, alpha:1)
let darkColor = UIColor(red:0.098,  green:0.118,  blue:0.141, alpha:1)
let darkLightColor = UIColor(red:0.125,  green:0.153,  blue:0.184, alpha:1)
// let yellowColor = UIColor(red:0.996,  green:0.953,  blue:0, alpha:1)
let yellowColor = UIColor(red:1,  green:0.749,  blue:0.239, alpha:1)
let grayLightColor = UIColor(red:0.639,  green:0.639,  blue:0.639, alpha:1)
let redLightColor = UIColor(red:0.843,  green:0.267,  blue:0.259, alpha:1)
let blueColor = UIColor(red:0.165,  green:0.506,  blue:0.596, alpha:1)
let blueLightColor = UIColor(red:0.690,  green:0.839,  blue:0.875, alpha:1)


// for sort notification
let sortNotificationKey = "com.ckl.sortNotificationKey"
let unreadAllNotificationKey = "com.ckl.unreadAllNotificationKey"

// get string date fetched and turns it into a NSDate object
func stringToDate(dateStr:String) -> NSDate {
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    let dateFound = dateFormatter.dateFromString(dateStr)!
    
    return dateFound
}


// A little func to convert image into grayscale
func convertImageToGrayScale(_image:UIImage) -> UIImage {
    
    let imageRect : CGRect = CGRectMake(0, 0, _image.size.width, _image.size.height);
    let colorSpace : CGColorSpaceRef = CGColorSpaceCreateDeviceGray();
    let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.None.rawValue)
    let context : CGContextRef = CGBitmapContextCreate(nil, Int(_image.size.width), Int(_image.size.height), 8, 0, colorSpace, bitmapInfo)
    CGContextDrawImage(context, imageRect, _image.CGImage)
    let imageRef : CGImageRef = CGBitmapContextCreateImage(context)
    let newImage : UIImage = UIImage(CGImage: imageRef)!
    
    return newImage;
    
}