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
    
    func getHomeTimeline(quantity: Int, maxID: Int?) -> SignalProducer<[Tweet], TwitterError> {
        return SignalProducer(value: tweets)
    }
    
}

class ThreeTweetsService : TwitterServiceType {
    func getHomeTimeline(quantity: Int, maxID: Int?) -> SignalProducer<[Tweet], TwitterError> {
        var tweetArray : [Tweet] = []
        for i in ((maxID ?? 0) + 1)...((maxID ?? 0) + 3) {
            tweetArray.append(Tweet(id: i, createdAt: NSDate(), text: "Tweet text", user: User(name: "User", profileImageURL: NSURL()), userEntities: [], hashtagEntities: []))        }
        return SignalProducer(value: tweetArray)
    }
}

class EmptyImageFetcher : ImageFetcherType {
    
    func fetchImage(imageURL: NSURL) -> SignalProducer<UIImage, ImageFetcherError> {
        return SignalProducer(value: UIImage(named: "noPicture")!)
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
                    expect(feedVM.tweetsCount) == 0
                    expect(feedVM.tweets.value.map { $0.id }) == []
                }
                
                describe ("#searchForTweets") {
                    
                    it ("should return empty array when asked once") { waitUntil { done in
                        feedVM.searchForTweets.apply(.None).startWithCompleted {
                            expect(feedVM.tweetsCount) == 0
                            expect(feedVM.tweets.value.map { $0.id }) == []
                            done()
                        }
                    }}
                    
                    it ("should return empty array when asked twice") { waitUntil { done in
                        feedVM.searchForTweets.apply(.None)
                            .then(feedVM.searchForMoreTweets.apply(.None))
                            .then(feedVM.searchForTweets.apply(.None))
                            .start { event in
                                switch event {
                                case .Completed:
                                    expect(feedVM.tweetsCount) == 0
                                    expect(feedVM.tweets.value.map { $0.id }) == []
                                    done()
                                default:
                                    break
                                }
                            }
                    }}
                    
                }
                
                describe ("#searchForMoreTweets") {
                    
                    it ("should have empty array when asked for more") { waitUntil { done in
                        feedVM.searchForMoreTweets.apply(.None).startWithCompleted {
                            expect(feedVM.tweetsCount) == 0
                            expect(feedVM.tweets.value.map { $0.id }) == []
                            done()
                        }
                    }}
                    
                }
                
            }
            
            context("with enough tweets as asked provided each time") {
                beforeEach {
                    feedVM = FeedViewModel(pageQuantity: 3, twitterService: ThreeTweetsService(), imageFetcher: EmptyImageFetcher())
                }
                
                describe ("searchForTweets") {
                    
                    it ("should return array of 3 tweets when asked once") { waitUntil { done in
                        feedVM.searchForTweets.apply(.None).startWithCompleted {
                            expect(feedVM.tweetsCount) == 3
                            expect(feedVM.tweets.value.map { $0.id } ) == [1,2,3]
                            done()
                        }
                    }}
                    
                    it ("should return array of 3 tweets when asked twice") { waitUntil { done in
                        feedVM.searchForTweets.apply(.None)
                            .then(feedVM.searchForMoreTweets.apply(.None))
                            .then(feedVM.searchForTweets.apply(.None))
                            .start { event in
                                switch event {
                                case .Completed:
                                    expect(feedVM.tweetsCount) == 3
                                    expect(feedVM.tweets.value.map { $0.id } ) == [1,2,3]
                                    done()
                                default:
                                    break
                                }
                            }
                    }}
                    
                }
                
                describe ("searchForMoreTweets") {
                    
                    it ("should have array of 6 tweets when asked for more once") { waitUntil { done in
                        feedVM.searchForTweets.apply(.None).startWithCompleted {
                            feedVM.searchForMoreTweets.apply(.None).startWithCompleted {
                                expect(feedVM.tweetsCount) == 6
                                expect(feedVM.tweets.value.map { $0.id } ) == [1,2,3,4,5,6]
                                done()
                            }
                        }
                    }}
                    
                    it ("should have array of 9 tweets when asked for more twice") { waitUntil { done in
                        feedVM.searchForTweets.apply(.None)
                            .then(feedVM.searchForMoreTweets.apply(.None))
                            .then(feedVM.searchForMoreTweets.apply(.None))
                            .start { event in
                                switch event {
                                case .Completed:
                                    expect(feedVM.tweetsCount) == 9
                                    expect(feedVM.tweets.value.map { $0.id } ) == [1,2,3,4,5,6,7,8,9]
                                    done()
                                default:
                                    break
                                }
                            }
                    }}
                    
                }
                
            }
            
        }
        
    }
    
}
