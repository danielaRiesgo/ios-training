//
//  Extensions.swift
//  ejercicioTwitter
//
//  Created by Daniela Riesgo on 2/19/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Foundation
import Accounts
import ReactiveCocoa
import Social

extension ACAccountStore {
    
    func requestAccessToAccountWithType(accountType: ACAccountType!, options: [NSObject : AnyObject]!) -> SignalProducer<Bool, AccountError> {
        return SignalProducer { observable, disposable in
            self.requestAccessToAccountsWithType(accountType, options: options) {
                granted, error in
                if (error == nil) {
                    observable.sendNext(granted)
                    observable.sendCompleted()
                } else {
                    observable.sendFailed(.NoAccessGranted(error))
                }
            }
        }
    }
    
    func accountsWithAccountType(accountType: ACAccountType!) -> SignalProducer<ACAccount, AccountError> {
        return SignalProducer { observable, disposable in
            let accounts : [AnyObject]! = self.accountsWithAccountType(accountType)
            if accounts != nil {
                if case let twitterAccount as ACAccount = accounts.first {
                    observable.sendNext(twitterAccount)
                    observable.sendCompleted()
                } else {
                    observable.sendFailed(.NoAccountAvailable)
                }
            } else {
                observable.sendFailed(.NoAccountAvailable)
            }
            
        }
    }
    
}


extension SLRequest {
    
    func performWithSignal() -> SignalProducer<(NSData, NSHTTPURLResponse), NSError> {
        return SignalProducer { observable, disposable in
            self.performRequestWithHandler { (data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) in
                if (error == nil) {
                    observable.sendNext((data, urlResponse))
                    observable.sendCompleted()
                } else {
                    observable.sendFailed(error)
                }
            }
        }
    }
    
}