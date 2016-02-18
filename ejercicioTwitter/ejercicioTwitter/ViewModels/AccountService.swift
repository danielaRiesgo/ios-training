//
//  AccountService.swift
//  ejercicioTwitter
//
//  Created by Daniela Riesgo on 2/17/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Accounts
import Result

protocol AccountServiceType {
    
    func getTwitterAccount (completion: (Result<ACAccount, AccountError>) -> ())
    
}

enum AccountError : ErrorType {
    case NoAccessGranted(ErrorType)
    case NoAccountAvailable
}


class AccountService : AccountServiceType {

    let accountStore = ACAccountStore()
    
    func getTwitterAccount (completion: (Result<ACAccount, AccountError>) -> ()) {
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil){ (granted, error) in
            if (error == nil) {
                let accounts = self.accountStore.accountsWithAccountType(accountType)
                if accounts != nil {
                    if case let twitterAccount as ACAccount = accounts.first {
                        completion(.Success(twitterAccount))
                    } else {
                        completion(.Failure(.NoAccountAvailable))
                    }
                } else {
                    completion(.Failure(.NoAccountAvailable))
                }
            } else {
                completion(.Failure(.NoAccessGranted(error)))
            }
        }
    }
    
}
