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
    private let _searchForMoreTweets: Action<AnyObject?, [TweetViewModel], TwitterError>
    
    let pageCount : Int
    
    var tweetsCount : Int {
        return tweets.value.count
    }
    
    init(pageQuantity: Int, twitterService: TwitterServiceType, imageFetcher: ImageFetcherType) {
        pageCount = pageQuantity
        _twitterService = twitterService
        _imageFetcher = imageFetcher
        tweets = AnyProperty(_tweets)
        searchForTweets = Action { _ in
            twitterService.getHomeTimeline(pageQuantity).map { tweets in
                tweets.map { TweetViewModel(tweet: $0) }
            }
            .observeOn(UIScheduler())
        }
        _searchForMoreTweets = Action { _ in
            twitterService.getMoreHomeTimeline(pageQuantity).map { tweets in
                tweets.map { TweetViewModel(tweet: $0) }
                }
                .observeOn(UIScheduler())
        }
        _tweets <~ searchForTweets.values
    }
    
    func searchForMoreTweets() {
        _searchForMoreTweets.apply(.None).startWithNext { page in
            print("Carga más")
            print("Nuevos: \(page.map { $0.id })")
            self._tweets.value = self._tweets.value + page
            print("En total: \(self._tweets.value.map { $0.id })")
        }

    }
    
    subscript(index: Int) -> TweetViewModel {
        return _tweets.value[index]
    }
    
}
