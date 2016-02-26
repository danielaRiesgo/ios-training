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
    
    let searchForTweets: Action<AnyObject?, [TweetViewModel], TwitterError>
    var searchForMoreTweets : Action<AnyObject?, [TweetViewModel], TwitterError>
    
    var tweetsCount : Int {
        return tweets.value.count
    }
    
    init(pageQuantity: Int, twitterService: TwitterServiceType, imageFetcher: ImageFetcherType = ImageFetcher()) {
        _twitterService = twitterService
        _imageFetcher = imageFetcher
        tweets = AnyProperty(_tweets)
        searchForTweets = Action { _ in
            twitterService.getHomeTimeline(pageQuantity, maxID: .None).map { tweets in
                tweets.map { TweetViewModel(tweet: $0) }
                }
                .observeOn(UIScheduler())
        }
        
        searchForMoreTweets = Action { _ in SignalProducer(error: .CredentialsError(.NoAccountAvailable)) } //Para que el compilador no se queje en lo siguiente.
        searchForMoreTweets = Action { _ in
            twitterService.getHomeTimeline(pageQuantity, maxID: self._tweets.value.last?.id).map { tweets in
                tweets.map { TweetViewModel(tweet: $0) }
                }
                .observeOn(UIScheduler())
        }
        _tweets <~ searchForTweets.values
        searchForMoreTweets.values.observeNext { page in
            self._tweets.value = self._tweets.value + page
        }
    }
    
    subscript(index: Int) -> TweetViewModel {
        return _tweets.value[index]
    }
    
}
