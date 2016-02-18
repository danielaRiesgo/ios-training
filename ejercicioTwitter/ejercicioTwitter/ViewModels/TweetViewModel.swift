//
//  TweetViewModel.swift
//  ejercicioTwitter
//
//  Created by Daniela Riesgo on 2/17/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Foundation
import ReactiveCocoa

struct TweetViewModel {

    let text: NSAttributedString
    
    let timeAgo: String
    
    var userName: String {
        return _tweet.user.name
    }

    let fetchProfileImage: SignalProducer<UIImage, ImageFetcherError>
    
    private let _tweet: Tweet
    
    init(tweet: Tweet, imageFetcher: ImageFetcherType = ImageFetcher()) {
        _tweet = tweet
        fetchProfileImage = imageFetcher.fetchImage(tweet.user.profileImageURL).observeOn(UIScheduler())
        timeAgo = tweet.createdAt.timeAgoSinceNow()
        text = parseTweetContent(tweet)
    }
    
}

private func parseTweetContent(tweet: Tweet) -> NSAttributedString {
    let text = NSMutableAttributedString(string: tweet.text)
    
    for userEntity in tweet.userEntities {
        let length = userEntity.endIndex - userEntity.startIndex
        text.addAttribute(NSLinkAttributeName, value: userEntity.entityURL, range: NSRange(location: userEntity.startIndex, length: length))
    }
    
    return text
}