//
//  ContactsAgendaViewModel.swift
//  ejercicioContactos
//
//  Created by Daniela Riesgo on 2/29/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Foundation
import ReactiveCocoa
import enum Result.NoError

final class ContactsAgendaViewModel {
    
    enum Filter : Int {
        case All = 1
        case Favourites = 0
    }
    
    let activeFilter = MutableProperty<Filter>(.All)
    
    private let _contactService : ContactServiceType
    private let _persistenceService : PersistenceServiceType

    private let _contacts : MutableProperty<[ContactViewModel]>
    let contactsShown : AnyProperty<[ContactViewModel]>
    
//    private var _foo: Action<AnyObject?, [ContactViewModel], NoError>!
//    var foo: Action<AnyObject?, [ContactViewModel], NoError> {
//        return _foo
//    }
//    
//    private(set) var bar: Action<AnyObject?, [ContactViewModel], NoError>!
//
    
    var contactsCount : Int {
        return contactsShown.value.count
    }
    
    init(contactService: ContactServiceType = ContactService()) {
        self._contacts = MutableProperty<[ContactViewModel]>([])
        self._contactService = contactService
        
        let contactsNeedFiltering = SignalProducer<Signal<[ContactViewModel], NoError>, NoError>(values: [self._contacts.signal, self.activeFilter.signal.map { [unowned self] _ in self._contacts.value }]).flatten(.Merge)

        let filteredContacts = contactsNeedFiltering.map { [unowned self] contacts -> [ContactViewModel] in
            switch self.activeFilter.value {
            case .Favourites: return contacts.filter({ $0.favourited })
            default: return contacts
            }
        }
        self.contactsShown = AnyProperty(initialValue: [], producer: filteredContacts)
        print("Definió los contactsShown")

        
        let mapping : (event: ContactServiceEvent) -> SignalProducer<[ContactViewModel], ContactsFetchingError> = { event in
            switch event {
            case .ContactsChanged:
                return contactService.getContacts().map { ContactViewModel(contact: $0, contactService: contactService) }
            case .FavouriteChanged(let newContact):
                var newContacts = self._contacts.value
                let index = newContacts.map{$0.id}.indexOf(newContact.id)!
                newContacts[index] = ContactViewModel(contact: newContact, contactService: contactService)
                return SignalProducer<[ContactViewModel], ContactsFetchingError>(value: newContacts)
            }
        }

        let updatingContactsSP = SignalProducer(signal: contactService.events).flatMap(.Concat, transform: mapping )
        print("Definió los updatingContactsSP")
        self._contacts <~ (updatingContactsSP.flatMapError { error in
            print("Error fetching contacts: \(error)")
            return SignalProducer.empty
        })
        
    }
    
    subscript(index: Int) -> ContactViewModel {
        return contactsShown.value[index]
    }
    
}
