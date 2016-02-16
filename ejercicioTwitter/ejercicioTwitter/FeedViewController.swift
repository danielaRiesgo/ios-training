//
//  FeedViewController.swift
//  ejercicioTwitter
//
//  Created by Daniela Riesgo on 2/11/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import UIKit
import Accounts
import Social
import Foundation



class FeedViewController: UITableViewController {
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.searchForTweets(20) { _ in self.tableView.reloadData() }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweetsCount
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetTableCell") as! TweetTableCell
        let tweet = self.viewModel.getTweet(indexPath.row)//[indexPath.row]
        cell.tweetTextView.attributedText = tweet.text
        cell.userNameLabel.text = tweet.user.name
        cell.timeAgoLabel.text = tweet.timeAgo
        let task = tweet.user.downloadProfileImage { data, error in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()) { cell.userImage.image = UIImage(data: data!)! }
            } else {
                print("Error fetching image \(error)")
            }
        }
        cell.onPrepareForReuse = { _ in task.cancel() }
        return cell
    }

}