//
//  Tweet.swift
//  ejercicioTwitter
//
//  Created by Daniela Riesgo on 2/15/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import UIKit
import DateTools

class Tweet {

    var createdAt: NSDate
    var text: NSMutableAttributedString
    var user: User
    var tableView: UITableView
    
    init(jsonDict: NSDictionary, tableView: UITableView) {
        self.tableView = tableView
        let date = jsonDict["created_at"] as! String
        //print("Date recibido: ", date)
        self.createdAt = NSDate(string: date, formatString: "EEE MMM dd HH:mm:ssZ yyyy")
        self.text = NSMutableAttributedString(string: jsonDict["text"] as! String)
        let entities = jsonDict["entities"] as! NSDictionary
        
        let urls = entities["urls"] as! NSArray
        for urlJson in urls {
            let urlLink = NSURL(string: urlJson["expanded_url"] as! String)!
            let startIndex = urlJson["indices"]!![0] as! Int
            let endIndex = urlJson["indices"]!![1] as! Int
            self.text.addAttribute(NSLinkAttributeName, value: urlLink, range: NSRange(location: startIndex, length: endIndex-startIndex))
        }
        
        let media = entities.objectForKey("media")
        if media != nil {
            let mediaArray = media as! NSArray
            for mediaJson in mediaArray {
                let urlLink = NSURL(string: mediaJson["expanded_url"] as! String)!
                let startIndex = mediaJson["indices"]!![0] as! Int
                let endIndex = mediaJson["indices"]!![1] as! Int
                self.text.addAttribute(NSLinkAttributeName, value: urlLink, range: NSRange(location: startIndex, length: endIndex-startIndex))
            }
        }
        
        let users = entities["user_mentions"] as! NSArray
        for userJson in users {
            let userName =  userJson["screen_name"] as! String
            let urlLink = NSURL(string: "https://twitter.com/" + userName)!
            let startIndex = userJson["indices"]!![0] as! Int
            let endIndex = userJson["indices"]!![1] as! Int
            self.text.addAttribute(NSLinkAttributeName, value: urlLink, range: NSRange(location: startIndex, length: endIndex-startIndex))
        }
        
        self.user = User(jsonDict: jsonDict["user"] as! NSDictionary, tableView: tableView)
    }
    
    func getTimeAgo() -> String {
        return self.createdAt.timeAgoSinceNow()
    }
    
}
