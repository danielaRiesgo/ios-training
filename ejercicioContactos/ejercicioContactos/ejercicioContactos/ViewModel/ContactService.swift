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
import Result

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
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: CNContactStoreDidChangeNotification, object: nil)
    }
    
    func contactsChanged(notification: NSNotification) {
        if (notification.name == CNContactStoreDidChangeNotification) {
            print("La info es: \(notification.userInfo)")
            self._signalObserver.sendNext(.ContactsChanged)
            //Le avisa que los contactos cambiaron, cuando llame a getContacts va a conseguir los nuevos.
        }
    }
    
    func getContacts() -> SignalProducer<[Contact], ContactsFetchingError> {
        //print("Entra a pedir contactos")
        let requestSP : SignalProducer = self._contactStore.requestAccessForEntityType(.Contacts).observeOn(UIScheduler())
        return requestSP.mapError { ContactsFetchingError.NoPermission($0) }
            .flatMap(.Concat) { _ -> SignalProducer<[Contact], ContactsFetchingError> in
                let contacts = self.getAllContainers()
                    .flatMap(self.getAllContacts)
                    .flatMap(self.getFinalContacts)
                return SignalProducer(result: contacts)
            }
    }
    
    func updateFavourite(contact: Contact, favourite: Bool) -> SignalProducer<Contact, PersistingError> {
        //print("Entra a update")
        return self._persistenceService.updateFavourite(contact.toggleFavourite())
            .on(next: { self._signalObserver.sendNext(.FavouriteChanged($0)) }).observeOn(UIScheduler())
    }
    
    
}

private extension ContactService {
    
    func parseContact(cnContact: CNContact) -> Contact {
        //print("Entra a parsear CNContact")
        let fullName = CNContactFormatter.stringFromContact(cnContact, style: .FullName)!
        let emailAddress = cnContact.emailAddresses.first?.value as? String
        let phoneNumber : String? = (cnContact.phoneNumbers.first?.value as? CNPhoneNumber)?.stringValue
        let imageData : NSData? = cnContact.thumbnailImageData
        return Contact(id: cnContact.identifier, name: fullName, email: emailAddress, phoneNumber: phoneNumber, imageData: imageData)
    }
    
    func getAllContainers() -> Result<[CNContainer], ContactsFetchingError> {
        return Result<[CNContainer], ContactsFetchingError>(attempt: { try self._contactStore.containersMatchingPredicate(nil) })
    }
    
    func getAllContacts(containers: [CNContainer]) -> Result<[CNContact], ContactsFetchingError> {
        var contacts: [CNContact] = []
        for container in containers {
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
                return .Failure(.FetchingContactsFromContainerError(container))
            }
        }
        return .Success(contacts)
    }
    
    func getFinalContacts(cncontacts: [CNContact]) -> Result<[Contact], ContactsFetchingError> {
        let favouritesIds = self._persistenceService.getFavourites()
        let contacts : [Contact] = cncontacts.map(self.parseContact)
        let finalContacts = contacts.map { contact -> Contact in
            if (favouritesIds.indexOf(contact.id) != nil) {
                return Contact(id: contact.id, name: contact.name, email: contact.email, phoneNumber: contact.phone, imageData: contact.image, favourite: true)
            } else {
                return contact
            }
        }
        return .Success(finalContacts)
    }
    
}

private extension Contact {
    
    func toggleFavourite() -> Contact {
        return Contact(id: id, name: name, email: email, phoneNumber: phone, imageData: image, favourite: !favourited)
    }
    
}