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
    
    var events : Signal<ContactServiceEvent, NoError> { get }
    func getContacts() -> SignalProducer<[Contact], ContactsFetchingError>
    func updateFavourite(contact: Contact, favourite: Bool) -> SignalProducer<Contact, PersistingError>
    
}

final class ContactService : ContactServiceType {
    
    private let (_events, _signalObserver) = Signal<ContactServiceEvent, NoError>.pipe()
    
    private let _contactStore = CNContactStore()
    private let _persistenceService : PersistenceServiceType
    
    private var contacts : [Contact]?
    private var contactsIds : [String: Int] = [:]
    
    private var _notificationDisposable: Disposable? = Optional.None
    private let _notificationCenter: NSNotificationCenter
    
    var events : Signal<ContactServiceEvent, NoError> {
        return _events
    }
    
    init(persistenceService : PersistenceServiceType = PersistenceService(), notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter()) {
        _persistenceService = persistenceService
        _notificationCenter = notificationCenter
        _notificationDisposable = notificationCenter.rac_notifications(CNContactStoreDidChangeNotification)
            .map { _ in ContactServiceEvent.ContactsChanged }
            .on(next: { [unowned self] _ in self.invalidateCache() })
            .start(_signalObserver)
    }
    
    deinit {
        _notificationDisposable?.dispose()
    }
    
    func invalidateCache() {
        contacts = nil
        contactsIds = [:]
    }
    
    func getContacts() -> SignalProducer<[Contact], ContactsFetchingError> {
        //print("Entra a pedir contactos")
        if (contacts != nil) { return SignalProducer(value: contacts!) }
        let requestSP : SignalProducer = self._contactStore.requestAccessForEntityType(.Contacts).observeOn(UIScheduler())
        return requestSP.mapError { ContactsFetchingError.NoPermission($0) }
            .flatMap(.Concat) { _ -> SignalProducer<[Contact], ContactsFetchingError> in
                let contacts = self.getAllContainers()
                    .flatMap(self.getAllContacts)
                    .flatMap(self.getFinalContacts)
                self.contacts = contacts.value
                if (self.contacts != nil) {
                    for (index, contact) in self.contacts!.enumerate() {
                        self.contactsIds[contact.id] = index
                    }
                }
                return SignalProducer(result: contacts)
            }
    }
    
    func updateFavourite(contact: Contact, favourite: Bool) -> SignalProducer<Contact, PersistingError> {
        //print("Entra a update")
        return self._persistenceService.updateFavourite(contact.toggleFavourite())
            .on(next: {
                self.contacts?[self.contactsIds[$0.id]!] = $0
                self._signalObserver.sendNext(.FavouriteChanged($0))
            }).observeOn(UIScheduler())
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
            let keys = [
                CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
                CNContactEmailAddressesKey,
                CNContactPhoneNumbersKey,
                CNContactImageDataAvailableKey,
                CNContactThumbnailImageDataKey
            ]
            do {
                let containerResults = try _contactStore.unifiedContactsMatchingPredicate(fetchPredicate, keysToFetch:keys)
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
        return .Success(finalContacts.sort { $0.name < $1.name })
    }
    
}

private extension Contact {
    
    func toggleFavourite() -> Contact {
        return Contact(id: id, name: name, email: email, phoneNumber: phone, imageData: image, favourite: !favourited)
    }
    
}