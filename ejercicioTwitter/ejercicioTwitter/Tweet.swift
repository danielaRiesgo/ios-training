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
        var date = jsonDict["created_at"] as! String
        print("Date como vino: ", date)
        date.removeRange(date.startIndex..<date.startIndex.advancedBy(4))
        date.removeRange(date.endIndex.advancedBy(-10)..<date.endIndex.advancedBy(-4))
        print("Date modificado: ", date)
        self.createdAt = NSDate(string: date, formatString: "MMM dd HH:mm:SS YYYY")
        self.text = jsonDict["text"] as! String
        self.user = User(jsonDict: jsonDict["user"] as! NSDictionary, tableView: tableView)
    }
    
    func getTimeAgo() -> String {
        return self.createdAt.timeAgoSinceNow()
    }
    
}
