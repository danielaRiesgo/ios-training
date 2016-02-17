//
//  TweetViewModel.swift
//  ejercicioTwitter
//
//  Created by Daniela Riesgo on 2/17/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Foundation


class TweetViewModel {

    let text: NSAttributedString
    let timeAgo : String
    let userName : String
    let userImageURL : NSURL
    private let imageFetcher: ImageFetcherType
    
    init(text: NSAttributedString, timeAgo: String, userName: String, userImageURL: NSURL, imageFetcher: ImageFetcherType) {
        self.text = text
        self.timeAgo = timeAgo
        self.userName = userName
        self.userImageURL = userImageURL
        self.imageFetcher = imageFetcher
    }
    
    
    func downloadProfileImage(URLSession: NSURLSession = NSURLSession.sharedSession(), completion: (NSData?, NSError?) -> ()) -> NSURLSessionDataTask {
        let task = self.imageFetcher.downloadProfileImage(self.userImageURL, URLSession: URLSession, completion: completion)
        return task
    }
    
}
