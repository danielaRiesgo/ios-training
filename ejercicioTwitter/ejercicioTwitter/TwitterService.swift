//
//  TwitterService.swift
//  ejercicioTwitter
//
//  Created by Daniela Riesgo on 2/17/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Accounts
import Social

class TwitterService {

    let accountStore = ACAccountStore();
    
    func searchForTweets(quantity: Int, dataCompletion: ([JSON]) -> (), completion: () -> ()) {
    
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil){ (granted, error) in
            if (error == nil) {
                let accounts = self.accountStore.accountsWithAccountType(accountType)
                if accounts != nil {
                    if case let twitterAccount as ACAccount = accounts.first {
                        let requestURL = NSURL(string:"https://api.twitter.com/1.1/statuses/home_timeline.json?")
                        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: requestURL, parameters: ["count" : quantity])
                        request.account = twitterAccount
                        request.performRequestWithHandler( { (data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) in
                            if (error == nil) {
                                print("Data acquired!")
                                do {
                                    let jsonArray = try NSJSONSerialization.JSONObjectWithData(data, options:[]) as! [JSON]
                                    dataCompletion(jsonArray)
                                }
                                catch {
                                    print("Error: \(error)")
                                }
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    //print("In MAIN THREAD")
                                    completion()
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
    
    
    func downloadProfileImage(url: NSURL, URLSession: NSURLSession = NSURLSession.sharedSession(), completion: (NSData?, NSError?) -> ()) -> NSURLSessionDataTask {
        let task = URLSession.dataTaskWithRequest(NSURLRequest(URL: url)) { data, _, error in
            completion(data, error)
        }
        task.resume()
        return task
    }



}
