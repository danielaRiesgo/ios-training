//
//  TweetTableCell.swift
//  ejercicioTwitter
//
//  Created by Daniela Riesgo on 2/15/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import UIKit
import enum Result.NoError
import ReactiveCocoa

final class TweetTableCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    
    var prepareForReuseProducer: SignalProducer<(), NoError> {
        return rac_prepareForReuseSignal
            .toSignalProducer()
            .flatMapError { _ in SignalProducer.empty }
            .map { _ in () }
    }
    
    func bindViewModel(tweet: TweetViewModel) {
        userNameLabel.text = tweet.userName
        timeAgoLabel.text = tweet.timeAgo
        tweetTextView.attributedText = tweet.text
        
        tweet.fetchProfileImage.takeUntil(prepareForReuseProducer)
            .startWithNext { self.userImage.image = $0 }
    }

    
}
