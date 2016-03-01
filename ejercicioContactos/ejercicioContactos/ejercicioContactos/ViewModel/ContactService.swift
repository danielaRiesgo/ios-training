//
//  ContactService.swift
//  ejercicioContactos
//
//  Created by Daniela Riesgo on 2/29/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Foundation
import Contacts
import ReactiveCocoa

enum ContactsFetchingError : ErrorType {
    case NoPermission(NSError)
    case FetchingContainersError
    case FetchingContactsFromContainerError(CNContainer)
}

protocol ContactServiceType {
    
    func getContacts() -> SignalProducer<[Contact], ContactsFetchingError>
    
}

class ContactService : ContactServiceType {
    
    let contactStore = CNContactStore()
    
    func getContacts() -> SignalProducer<[Contact], ContactsFetchingError> {
        //print("Entra a pedir contactos")
        let requestSP : SignalProducer = self.contactStore.requestAccessForEntityType(.Contacts)
        return requestSP.mapError { ContactsFetchingError.NoPermission($0) }
            .flatMap(.Concat) { _ -> SignalProducer<[Contact], ContactsFetchingError> in
                let allContainers: [CNContainer]
                do {
                    allContainers = try self.contactStore.containersMatchingPredicate(nil)
                } catch {
                    return SignalProducer(error: .FetchingContainersError)
                }
                var contacts: [CNContact] = []
                for container in allContainers {
                    let fetchPredicate = CNContact.predicateForContactsInContainerWithIdentifier(container.identifier)
                    do {
                        let containerResults = try self.contactStore.unifiedContactsMatchingPredicate(fetchPredicate, keysToFetch:
                            [ CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
                                CNContactEmailAddressesKey,
                                CNContactPhoneNumbersKey,
                                CNContactImageDataAvailableKey,
                                CNContactThumbnailImageDataKey ])
                        contacts.appendContentsOf(containerResults)
                    } catch {
                        return SignalProducer(error: .FetchingContactsFromContainerError(container))
                    }
                }
                return SignalProducer(value: contacts.map(parseContact))
            }
    }
    
    
}

private func parseContact(cnContact: CNContact) -> Contact {
    //print("Entra a parsear CNContact")
    let fullName = CNContactFormatter.stringFromContact(cnContact, style: .FullName)!
    let emailAddress = cnContact.emailAddresses.first?.value as? String
    let phoneNumber : String? = (cnContact.phoneNumbers.first?.value as! CNPhoneNumber).stringValue
    let imageData : NSData? = cnContact.thumbnailImageData //.imageData ? Y tira error de noFetchedProperty
    return Contact(name: fullName, email: emailAddress, phoneNumber: phoneNumber, imageData: imageData)
    
}