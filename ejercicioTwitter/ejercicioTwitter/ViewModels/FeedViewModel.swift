//
//  FeedViewModel.swift
//  ejercicioTwitter
//
//  Created by Daniela Riesgo on 2/16/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Foundation
import ReactiveCocoa

final class FeedViewModel {

    private let _twitterService : TwitterServiceType
    private let _imageFetcher: ImageFetcherType
    private let _tweets = MutableProperty<[TweetViewModel]>([])
    
    let tweets: AnyProperty<[TweetViewModel]>
    
    let searchForTweets: Action<Int, [TweetViewModel], TwitterError>
    
    var tweetsCount : Int {
        return tweets.value.count
    }
    
    init(twitterService: TwitterServiceType, imageFetcher: ImageFetcherType) {
        _twitterService = twitterService
        _imageFetcher = imageFetcher
        tweets = AnyProperty(_tweets)
        searchForTweets = Action { tweetsAmount in
            twitterService.getHomeTimeline(tweetsAmount).map { tweets in
                tweets.map { TweetViewModel(tweet: $0) }
            }
            .observeOn(UIScheduler())
        }
        _tweets <~ searchForTweets.values
    }
    
    subscript(index: Int) -> TweetViewModel {
        return _tweets.value[index]
    }
    
}
