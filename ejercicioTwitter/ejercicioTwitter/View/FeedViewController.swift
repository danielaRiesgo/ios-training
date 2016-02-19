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
    let loadingMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.tweets.signal.observeNext { _ in self.tableView.reloadData() }
        viewModel.searchForTweets.errors.observeNext { error in
            print("Error fetching tweets \(error)")
        }
        viewModel.searchForTweets.apply(20).start()
        refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
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
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == viewModel.tweetsCount && !loadingMore) {
            //Aumentar la cantidad de tweets: viewModel.searchForTweets.apply(20).start()
            self.tableView.reloadData()
        }
    }
    
    func handleRefresh (refreshControl: UIRefreshControl) {
        viewModel.searchForTweets.apply(20).start()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
}