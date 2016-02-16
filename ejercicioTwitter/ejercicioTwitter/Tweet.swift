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
    var text: String
    var user: User
    var tableView: UITableView
    
    init(jsonDict: NSDictionary, tableView: UITableView) {
        self.tableView = tableView
        let date = jsonDict["created_at"] as! String
        //print("Date recibido: ", date)
        self.createdAt = NSDate(string: date, formatString: "EEE MMM dd HH:mm:ssZ yyyy")
        self.text = jsonDict["text"] as! String
        self.user = User(jsonDict: jsonDict["user"] as! NSDictionary, tableView: tableView)
    }
    
    func getTimeAgo() -> String {
        return self.createdAt.timeAgoSinceNow()
    }
    
}
