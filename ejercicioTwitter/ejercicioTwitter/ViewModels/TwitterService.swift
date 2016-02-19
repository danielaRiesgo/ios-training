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
import Result


enum TwitterError: ErrorType {
    
    case CredentialsError(AccountError)
    case FetchError(NSError)
    case DeserializationError(NSError)
    
}

protocol TwitterServiceType {
    
    func getHomeTimeline(quantity: Int) -> SignalProducer<[Tweet], TwitterError>
    
}


final class TwitterService : TwitterServiceType {
    
    private let accountService : AccountServiceType
    
    init(accountService: AccountServiceType) {
        self.accountService = accountService
    }
    
    func getHomeTimeline(quantity: Int) -> SignalProducer<[Tweet], TwitterError> {
       return accountService.getTwitterAccount()
            .mapError { TwitterError.CredentialsError($0) }
            .flatMap(.Concat) { fetchTimeline($0, quantity) }
            .flatMap(.Concat) { data, response in deserializeJSONArray(data) }
            .map { $0.map(parseTweet) }
    }

}

private typealias JSON = [String : AnyObject]

private func parseTweet(tweetJSON: JSON) -> Tweet {
    let dateString = tweetJSON["created_at"] as! String
    let date = NSDate(string: dateString, formatString: "EEE MMM dd HH:mm:ssZ yyyy")
    
    let entities = tweetJSON["entities"] as! JSON
    let hashtags = entities["hashtags"] as! [JSON]!
    let hashtagEntities = hashtags.map { hashtagEntityJSON -> TweetEntity in
        let hashtagName =  hashtagEntityJSON["text"] as! String
        let urlString = "https://twitter.com/hashtag/" + hashtagName
        let urlLink = NSURL(string: urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!
        let indices = hashtagEntityJSON["indices"] as! [Int]
        let startIndex = indices[0]
        let endIndex = indices[1]
        return TweetEntity(startIndex: startIndex, endIndex: endIndex, entityURL: urlLink, value: hashtagName)
    }
    
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
    
    return Tweet(createdAt: date, text: tweetJSON["text"] as! String, user: user, userEntities: userEntities, hashtagEntities: hashtagEntities)
}

private func deserializeJSONArray(data: NSData, options:  NSJSONReadingOptions) -> Result<[JSON], NSError> {
    let attempt: () throws -> [JSON] = { try NSJSONSerialization.JSONObjectWithData(data, options:options) as! [JSON] }
    return Result(attempt: attempt)
}

private func deserializeJSONArray(data: NSData) -> SignalProducer<[JSON], TwitterError> {
    return SignalProducer.attempt { deserializeJSONArray(data, options: []).mapError { .DeserializationError($0) } }
}

private func fetchTimeline(account: ACAccount, _ quantity: Int) -> SignalProducer<(NSData, NSHTTPURLResponse), TwitterError> {
    let requestURL = NSURL(string:"https://api.twitter.com/1.1/statuses/home_timeline.json?")
    let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: requestURL, parameters: ["count" : quantity])
    request.account = account
    return request.performWithSignal().mapError { .FetchError($0) }
}