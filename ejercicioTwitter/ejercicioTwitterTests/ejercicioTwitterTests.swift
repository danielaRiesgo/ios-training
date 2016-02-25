//
//  ejercicioTwitterTests.swift
//  ejercicioTwitterTests
//
//  Created by Daniela Riesgo on 2/11/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Quick
import Nimble
@testable import ejercicioTwitter

import ReactiveCocoa

class EmptyTwitterService : TwitterServiceType {
    
    var tweets: [Tweet] = []
    
    func getHomeTimeline(quantity: Int) -> SignalProducer<[Tweet], TwitterError> {
        return SignalProducer(value: tweets)
    }
    
    func getMoreHomeTimeline(quantity: Int) -> SignalProducer<[Tweet], TwitterError> {
        return SignalProducer(value: tweets)
    }
    
}

class ThreeTweetsService : TwitterServiceType {
    var tweetIndex : Int = 0
    func getHomeTimeline(quantity: Int, maxID: Int?) -> SignalProducer<[Tweet], TwitterError> {
        var tweetArray : Array = []
        for i in (maxID ?? 0)...((maxID + 2) ?? 2) {
            tweetArray.append(Tweet(id: i, createdAt: NSDate(), text: "Tweet text", user: User(name: "User", profileImageURL: NSURL()), userEntities: [], hashtagEntities: []))
            tweetIndex += 1
        }
        return SignalProducer(value: tweetArray)
    }
}

class EmptyImageFetcher : ImageFetcherType {
    
    func fetchImage(imageURL: NSURL) -> SignalProducer<UIImage, ImageFetcherError> {
        return SignalProducer(UIImage(named: "noPicture"))
    }
    
}

class FeedViewModelSpec: QuickSpec {
    
    override func spec() {
        describe("FeedViewModel") {
         
            var feedVM : FeedViewModel!
            
            context("when there are no tweets provided") {
                
                beforeEach {
                    feedVM = FeedViewModel(pageQuantity: 20, twitterService: EmptyTwitterService())
                }
                
                it ("should start without tweets") {
                    expect(feedVM.tweetsCount).to(equal(0))
                    expect(feedVM.tweets).to(equal([]))
                }
                
                describe ("#searchForTweets") {
                    
                    it ("should return empty array when asked once") { waitUntil {
                        feedVM.searchForTweets.apply(.None).start { _ in
                            expect(feedVM.tweetsCount).to(equal(0))
                            expect(feedVM.tweets).to(equal([]))
                        }
                    }}
                    
                    it ("should return empty array when asked twice") { waitUntil {
                        feedVM.searchForTweets.apply(.None).start { _ in waitUntil {
                            feedMV.searchForMoreTweets.apply(.None).start { _ in waitUntil {
                                feedVM.searchForTweets.apply(.None).start() { _ in
                                    expect(feedVM.tweetsCount).to(equal(0))
                                    expect(feedVM.tweets).to(equal([]))
                                }
                            }}
                        }}
                    }}
                    
                }
                
                describe ("#searchForMoreTweets") {
                    
                    it ("should have empty array when asked for more") {
                        feedVM.searchForMoreTweets()
                        expect(feedVM.tweetsCount).withTimeout(3).toEventually(equal(0))
                        expect(feedVM.tweets).withTimeout(3).toEventually(equal([]))
                    }
                    
                }
                
            }
            
            context("with enough tweets as asked provided each time") {
                beforeEach {
                    feedVM = FeedViewModel(pageQuantity: 3, twitterService: ThreeTweetsService(), imageFetcher: EmptyImageFetcher())
                    feedVM.searchForTweets.apply(.None).start()
                }
                
                describe ("searchForTweets") {
                    
                    it ("should return array of 3 tweets when asked once") {
                        expect(feedVM.tweetsCount).withTimeout(3).toEventually(equal(3))
                        expect(feedVM.tweets.map { $0.id } ).withTimeout(3).toEventually(equal([0,1,2]))
                    }
                    /* Y si no terminó el primero?*/
                    it ("should return array of 3 tweets when asked twice") {
                        feedMV.searchForMoreTweets()
                        feedVM.searchForTweets.apply(.None).start()
                        expect(feedVM.tweetsCount).withTimeout(3).toEventually(equal(3))
                        expect(feedVM.tweets.map { $0.id } ).withTimeout(3).toEventually(equal([0,1,2]))
                    }
                    
                }
                
                describe ("searchForMoreTweets") {
                    
                    it ("should have array of 6 tweets when asked for more once") {
                        feedVM.searchForMoreTweets()
                        expect(feedVM.tweetsCount).withTimeout(3).toEventually(equal(6))
                        expect(feedVM.tweets.map { $0.id } ).withTimeout(3).toEventually(equal([0,1,2,3,4,5]))
                    }
                    /* Y si ya se está ejecutando?
                    it ("should have array of 9 tweets when asked for more twice") {
                        feedVM.searchForMoreTweets()
                        feedVM.searchForMoreTweets()
                        expect(feedVM.tweetsCount).withTimeout(3).toEventually(equal(6))
                        expect(feedVM.tweets.map { $0.id } ).withTimeout(3).toEventually(contain(0,1,2,3,4,5))
                    }
                    */

                    
                }
                
            }
            
        }
        
    }
    
}
