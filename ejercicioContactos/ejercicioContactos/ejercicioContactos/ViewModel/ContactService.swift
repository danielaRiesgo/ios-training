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

enum ContactServiceEvent {
    /* Any event containing a contact is containing the new contact that must replace the one with its same id. */
    case DeletedContact(Contact)
    case UpdatedContact(Contact)
    case NewContact(Contact)
    
    case ContactsChanged
    case FavouriteChanged(Contact)
}

protocol ContactServiceType {
    
    var events : Signal<ContactServiceEvent, ContactsFetchingError> { get }
    func getContacts() -> SignalProducer<[Contact], ContactsFetchingError>
    func updateFavourite(contact: Contact, favourite: Bool) -> SignalProducer<Contact, PersistingError>
    
}

final class ContactService : ContactServiceType {
    
    private let _events : Signal<ContactServiceEvent, ContactsFetchingError>
    private let _signalObserver : Signal<ContactServiceEvent, ContactsFetchingError>.Observer
    
    private let _contactStore = CNContactStore()
    private let _persistenceService : PersistenceServiceType
    
    var events : Signal<ContactServiceEvent, ContactsFetchingError> {
        return _events
    }
    
    init(persistenceService : PersistenceServiceType = PersistenceService()) {
        self._persistenceService = persistenceService
        (self._events, self._signalObserver) = Signal.pipe()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contactsChanged:", name: CNContactStoreDidChangeNotification, object: nil)
    }
    
    func contactsChanged(notification: NSNotification) {
        if (notification.name == CNContactStoreDidChangeNotification) {
            print("La info es: \(notification.userInfo)")
            self._signalObserver.sendNext(.ContactsChanged)
            //Le avisa que los contactos cambiaron, cuando llame a getContacts va a conseguir los nuevos.
        }
    }
    
    func getContacts() -> SignalProducer<[Contact], ContactsFetchingError> {
        print("Entra a pedir contactos")
        let requestSP : SignalProducer = self._contactStore.requestAccessForEntityType(.Contacts)
        return requestSP.mapError { ContactsFetchingError.NoPermission($0) }
            .flatMap(.Concat) { _ -> SignalProducer<[Contact], ContactsFetchingError> in
                let allContainers: [CNContainer]
                do {
                    allContainers = try self._contactStore.containersMatchingPredicate(nil)
                } catch {
                    return SignalProducer(error: .FetchingContainersError)
                }
                var contacts: [CNContact] = []
                for container in allContainers {
                    let fetchPredicate = CNContact.predicateForContactsInContainerWithIdentifier(container.identifier)
                    do {
                        let containerResults = try self._contactStore.unifiedContactsMatchingPredicate(fetchPredicate, keysToFetch:
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
                let favouritesIds = self._persistenceService.getFavourites()
                return SignalProducer(value: contacts.map(parseContact)
                    .map { contact in
                        if (favouritesIds.indexOf(contact.id) != nil) {
                            return Contact(id: contact.id, name: contact.name, email: contact.email, phoneNumber: contact.phone, imageData: contact.image, favourite: true)
                        } else {
                            return contact
                        }
                    })
            }
    }
    
    func updateFavourite(contact: Contact, favourite: Bool) -> SignalProducer<Contact, PersistingError> {
        return self._persistenceService.updateFavourite(contact, newFavouritedState: favourite)
            .on(next: { self._signalObserver.sendNext(.FavouriteChanged($0)) })
    }
    
    
}

private func parseContact(cnContact: CNContact) -> Contact {
    //print("Entra a parsear CNContact")
    let fullName = CNContactFormatter.stringFromContact(cnContact, style: .FullName)!
    let emailAddress = cnContact.emailAddresses.first?.value as? String
    let phoneNumber : String? = (cnContact.phoneNumbers.first?.value as? CNPhoneNumber)?.stringValue
    let imageData : NSData? = cnContact.thumbnailImageData
    return Contact(id: cnContact.identifier, name: fullName, email: emailAddress, phoneNumber: phoneNumber, imageData: imageData)
    
}