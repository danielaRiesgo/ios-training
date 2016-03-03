//
//  Extensions.swift
//  ejercicioContactos
//
//  Created by Daniela Riesgo on 3/1/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Foundation
import Contacts
import ReactiveCocoa
import Result

extension CNContactStore {
    
    func requestAccessForEntityType(entityType: CNEntityType) -> SignalProducer<Bool, NSError> {
        return SignalProducer { observable, disposal in
            self.requestAccessForEntityType(entityType) {
                granted, error in
                if (error == nil) {
                    observable.sendNext(granted)
                    observable.sendCompleted()
                } else {
                    observable.sendFailed(error!)
                }
            }
        }
    }
    
}

extension SignalProducer {

    func liftError() -> SignalProducer<Value, NoError> {
        return self.flatMapError { _ in SignalProducer<Value, NoError>.empty }
    }
    
}