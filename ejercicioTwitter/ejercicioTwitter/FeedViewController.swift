//
//  FeedViewController.swift
//  ejercicioTwitter
//
//  Created by Daniela Riesgo on 2/11/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import UIKit
import Accounts

class FeedViewController: UITableViewController {
    
    let accountStore = ACAccountStore();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        //Ver lo de requestAccess...
        if let accounts = accountStore.accountsWithAccountType(accountType), case let twitterAccount as ACAccount = accounts.first {
            
            //Volver a hacer todo.
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Hacer las funciones del tableviewcontroller
    
}
