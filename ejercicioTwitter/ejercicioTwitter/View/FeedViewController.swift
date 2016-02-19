//
//  FeedViewController.swift
//  ejercicioTwitter
//
//  Created by Daniela Riesgo on 2/11/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import UIKit
import ReactiveCocoa


final class FeedViewController: UITableViewController {
    
    let viewModel = FeedViewModel(twitterService: TwitterService(accountService: AccountService()), imageFetcher: ImageFetcher())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.tweets.signal.observeNext { _ in self.tableView.reloadData() }
        viewModel.searchForTweets.errors.observeNext { error in
            print("Error fetching tweets \(error)")
        }
        viewModel.searchForTweets.apply(2).start()
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweetsCount
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetTableCell") as! TweetTableCell
        let tweet = self.viewModel[indexPath.row]
        cell.bindViewModel(tweet)
        return cell
    }

}