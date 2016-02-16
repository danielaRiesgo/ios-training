//
//  User.swift
//  ejercicioTwitter
//
//  Created by Daniela Riesgo on 2/15/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import UIKit

class User {
    
    var name: String
    var profileImage: UIImage!
    var tableView: UITableView
    
    init(jsonDict: NSDictionary, tableView: UITableView) {
        self.tableView = tableView
        self.name = jsonDict["name"] as! String
        self.profileImage = UIImage(named: "noPicture")!
        downloadImage(NSURL(string: jsonDict["profile_image_url_https"] as! String)!)
    }

    func downloadImage(url: NSURL){
        //print("Download Started: lastPathComponent: " + (url.lastPathComponent ?? ""))
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                //print("Download Finished: ", response?.suggestedFilename ?? "")
                self.profileImage = UIImage(data: data)
                self.tableView.reloadData()
            }
        }
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
        }.resume()
    }

}
