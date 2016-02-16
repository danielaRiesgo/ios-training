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
    
    let accountStore = ACAccountStore();
    var tweets: [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 500.0 //160.0
        
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil){ (granted, error) in
            if (error == nil) {
                let accounts = self.accountStore.accountsWithAccountType(accountType)
                if accounts != nil {
                    if case let twitterAccount as ACAccount = accounts.first {
                        let requestURL = NSURL(string:"https://api.twitter.com/1.1/statuses/home_timeline.json?count=5")
                        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: requestURL, parameters: nil)
                        request.account = twitterAccount
                        request.performRequestWithHandler( { (data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) in
                            if (error == nil) {
                                //print("Data acquired!")
                                do {
                                    let jsonArray : NSArray = try NSJSONSerialization.JSONObjectWithData(data, options:[]) as! NSArray
                                    //print(jsonArray)
                                    /*
                                    let formatter = NSDateFormatter()
                                    formatter.dateStyle = .MediumStyle
                                    formatter.timeStyle = .MediumStyle
                                    print("Ahora es: ", formatter.stringFromDate(NSDate()))
                                    */
                                    for jsonTweet in jsonArray {
                                        self.tweets.append(Tweet(jsonDict: jsonTweet as! NSDictionary, tableView: self.tableView))
                                        //print("JsonTweet: ", jsonTweet)
                                        //print("Tweet: ", jsonTweet["text"])
                                    }
                                }
                                catch {
                                    print("Error: \(error)")
                                }
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    print("In MAIN THREAD")
                                    self.tableView.reloadData()
                                })
                            } else {
                                print("Error performing request: \(error)")
                            }
                        })
                    } else {
                            print("No Twitter account available")
                    }
                } else {
                    print("No Twitter account available")
                }
            } else {
                print("Error getting access: \(error)")
            }
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tweet = self.tweets[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetTableCell") as! TweetTableCell
        cell.tweetTextView.attributedText = tweet.text
        cell.userNameLabel.text = tweet.user.name
        cell.userImage.image = tweet.user.profileImage
        cell.timeAgoLabel.text = tweet.getTimeAgo()
        
        cell.tweetTextView.sizeToFit()
        cell.tweetTextView.layoutIfNeeded()
        
        return cell
    }

}