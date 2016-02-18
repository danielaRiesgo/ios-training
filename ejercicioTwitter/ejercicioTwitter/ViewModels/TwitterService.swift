//
//  TwitterService.swift
//  ejercicioTwitter
//
//  Created by Daniela Riesgo on 2/17/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Accounts
import Social
import ReactiveCocoa

protocol TwitterServiceType {
    
    func getHomeTimeline(quantity: Int) -> SignalProducer<[Tweet], NSError>
    
}

final class TwitterService : TwitterServiceType {
    
    private let accountService : AccountServiceType
    private var _account : ACAccount?
    init(accountService: AccountServiceType) {
        self.accountService = accountService
    }
    
    func getHomeTimeline(quantity: Int) -> SignalProducer<[Tweet], NSError> {
        return SignalProducer { observable, disposable in
            self.accountService.getTwitterAccount({ result in
                switch result {
                case let .Success(account):
                    self._account = account
                    let requestURL = NSURL(string:"https://api.twitter.com/1.1/statuses/home_timeline.json?")
                    let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: requestURL, parameters: ["count" : quantity])
                    request.account = account
                    request.performRequestWithHandler( { (data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) in
                        if (error == nil) {
//                            let attempt: () throws -> [JSON] = {try NSJSONSerialization.JSONObjectWithData(data, options:[]) as! [JSON]}
//                            completion(Result(attempt: attempt))
                            do {
                                let tweets = try NSJSONSerialization.JSONObjectWithData(data, options:[]) as! [JSON]
                                observable.sendNext(tweets.map(parseTweet))
                                observable.sendCompleted()
                            } catch let error as NSError {
                                observable.sendFailed(error)
                            }
                        } else {
                            observable.sendFailed(error)
                        }
                    })
                    
                case let .Failure(error):
                    observable.sendFailed(error as NSError)
                }
            })
        }
    }
    

}

private typealias JSON = [String : AnyObject]

private func parseTweet(tweetJSON: JSON) -> Tweet {
    let dateString = tweetJSON["created_at"] as! String
    let date = NSDate(string: dateString, formatString: "EEE MMM dd HH:mm:ssZ yyyy")
    
    let entities = tweetJSON["entities"] as! JSON

    let users = entities["user_mentions"] as! [JSON]
    let userEntities = users.map { userEntityJSON -> TweetEntity in
        let userName =  userEntityJSON["screen_name"] as! String
        let urlLink = NSURL(string: "https://twitter.com/" + userName)!
        let indices = userEntityJSON["indices"] as! [Int]
        let startIndex = indices[0]
        let endIndex = indices[1]
        return TweetEntity(startIndex: startIndex, endIndex: endIndex, entityURL: urlLink, value: userName)
    }
    
    let userJSON = tweetJSON["user"] as! [String : AnyObject]
    let profileImageURL = NSURL(string: userJSON["profile_image_url_https"] as! String)!
    let username = userJSON["name"] as! String
    
    let user = User(name: username, profileImageURL: profileImageURL)
    
    return Tweet(createdAt: date, text: tweetJSON["text"] as! String, user: user, userEntities: userEntities)
}