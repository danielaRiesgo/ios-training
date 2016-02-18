//
//  TwitterService.swift
//  ejercicioTwitter
//
//  Created by Daniela Riesgo on 2/17/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Accounts
import Social
import Result

protocol TwitterServiceType {
    
    func getHomeTimeline(quantity: Int, completion: (Result<[JSON], NSError>) -> ())
    
}

class TwitterService : TwitterServiceType {
    
    private let accountService : AccountServiceType
    private var _account : ACAccount?
    init(accountService: AccountServiceType) {
        self.accountService = accountService
    }
    
    func getHomeTimeline(quantity: Int, completion: (Result<[JSON], NSError>) -> ()) {
    
        self.accountService.getTwitterAccount({ result in
            switch result {
                case let .Success(account):
                    self._account = account
                    let requestURL = NSURL(string:"https://api.twitter.com/1.1/statuses/home_timeline.json?")
                    let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: requestURL, parameters: ["count" : quantity])
                    request.account = account
                    request.performRequestWithHandler( { (data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) in
                        if (error == nil) {
                            let attempt: () throws -> [JSON] = {try NSJSONSerialization.JSONObjectWithData(data, options:[]) as! [JSON]}
                            completion(Result(attempt: attempt))
                        } else {
                            completion(.Failure(error))
                        }
                    })

                case let .Failure(error):
                    completion(.Failure(error as NSError))
            }
        })
    
    }
    

}
