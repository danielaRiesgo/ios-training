//
//  AccountService.swift
//  ejercicioTwitter
//
//  Created by Daniela Riesgo on 2/17/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Accounts
import ReactiveCocoa


enum AccountError : ErrorType {
    case NoAccessGranted(ErrorType)
    case NoAccountAvailable
}


protocol AccountServiceType {
    
    func getTwitterAccount () -> SignalProducer<ACAccount, AccountError>
    
}

final class AccountService : AccountServiceType {

    let accountStore = ACAccountStore()
    
    func getTwitterAccount () -> SignalProducer<ACAccount, AccountError> {
        let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        let requestSignalProducer : SignalProducer<Bool, AccountError> = accountStore.requestAccessToAccountWithType(twitterAccountType, options: nil)
        return requestSignalProducer.flatMap(.Concat) { _ -> SignalProducer<ACAccount, AccountError> in
            return self.accountStore.accountsWithAccountType(twitterAccountType)
        }
    }
    
}
