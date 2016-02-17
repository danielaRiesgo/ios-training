//
//  Feeder.swift
//  ejercicioTwitter
//
//  Created by Daniela Riesgo on 2/16/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Accounts
import Social

typealias JSON = [String : AnyObject]

func parseTweet(tweetJSON: JSON) -> Tweet {
    let dateString = tweetJSON["created_at"] as! String
    let date = NSDate(string: dateString, formatString: "EEE MMM dd HH:mm:ssZ yyyy")
    
    let text = NSMutableAttributedString(string: tweetJSON["text"] as! String)
    let entities = tweetJSON["entities"] as! NSDictionary
    let urls = entities["urls"] as! NSArray
    for urlJson in urls {
        let urlLink = NSURL(string: urlJson["expanded_url"] as! String)!
        let startIndex = urlJson["indices"]!![0] as! Int
        let endIndex = urlJson["indices"]!![1] as! Int
        text.addAttribute(NSLinkAttributeName, value: urlLink, range: NSRange(location: startIndex, length: endIndex-startIndex))
    }
    let media = entities.objectForKey("media")
    if media != nil {
        let mediaArray = media as! NSArray
        for mediaJson in mediaArray {
            let urlLink = NSURL(string: mediaJson["expanded_url"] as! String)!
            let startIndex = mediaJson["indices"]!![0] as! Int
            let endIndex = mediaJson["indices"]!![1] as! Int
            text.addAttribute(NSLinkAttributeName, value: urlLink, range: NSRange(location: startIndex, length: endIndex-startIndex))
        }
    }
    let users = entities["user_mentions"] as! NSArray
    for userJson in users {
        let userName =  userJson["screen_name"] as! String
        let urlLink = NSURL(string: "https://twitter.com/" + userName)!
        let startIndex = userJson["indices"]!![0] as! Int
        let endIndex = userJson["indices"]!![1] as! Int
        text.addAttribute(NSLinkAttributeName, value: urlLink, range: NSRange(location: startIndex, length: endIndex-startIndex))
    }
    
    let userJSON = tweetJSON["user"] as! [String : AnyObject]
    let profileImageURL = NSURL(string: userJSON["profile_image_url_https"] as! String)!
    let username = userJSON["name"] as! String
    
    let user = User(name: username, profileImageURL: profileImageURL)
    
    return Tweet(createdAt: date, text: text, user: user)
    
}



class Feeder {

    let twitterService = TwitterService();
    var tweets: [Tweet] = []
    
    var tweetsCount : Int {
        return tweets.count
    }
    
    func searchForTweets(quantity: Int, completion: () -> ()) {
        twitterService.searchForTweets(quantity, dataCompletion: { jsonData in self.tweets = jsonData.map(parseTweet) }, completion: completion)
        
    }
    
    subscript(index: Int) -> TweetViewModel {
        let tweet = self.tweets[index]
        return TweetViewModel(text: tweet.text, timeAgo: tweet.timeAgo, userName: tweet.user.name, userImageURL: tweet.user.profileImageURL)
    }
    
}
