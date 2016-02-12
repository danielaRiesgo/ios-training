//
//  FeedViewController.swift
//  ejercicioTwitter
//
//  Created by Daniela Riesgo on 2/11/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import UIKit
import Accounts

class FeedViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    let accountStore = ACAccountStore();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        let accounts = accountStore.accountsWithAccountType(accountType)
        if (accounts == nil || accounts.count == 0) {
            usernameLabel.text = "Username"
        } else {
            let twitterAccount = accounts[0] as! ACAccount
            usernameLabel.text = twitterAccount.username
        }
        profileImage.image = UIImage(named:"noPicture")!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
