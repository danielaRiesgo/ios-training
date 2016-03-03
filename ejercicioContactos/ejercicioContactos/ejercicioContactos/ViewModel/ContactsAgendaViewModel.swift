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
    
    enum Filter: Int {
        case All
        case Favourites
    }
    
    let activeFilter = MutableProperty<Filter>(.All)
    
    private let _contactService : ContactServiceType
    private let _persistenceService : PersistenceServiceType

    private let _contacts = MutableProperty<[ContactViewModel]>([])
    lazy private(set) var contactsShown: AnyProperty<[ContactViewModel]> = {
        let filteredContacts = Signal.merge([
            self._contacts.signal,
            self.activeFilter.signal.map { _ in self._contacts.value }
        ]).map(self.filterContacts)
        return AnyProperty(initialValue: [], signal: filteredContacts)
    }()
    
    
    lazy private var fetchContacts: Action<AnyObject?, [ContactViewModel], ContactsFetchingError> = {
        return Action { _ in self.fetchContactsFromService() }
    }()
    
    var contactsCount : Int {
        return contactsShown.value.count
    }
    
    init(contactService: ContactServiceType = ContactService(), persistenceService: PersistenceServiceType = PersistenceService()) {
        _contactService = contactService
        _persistenceService = persistenceService
        
        _contacts <~ fetchContacts.values
        _contacts <~ SignalProducer(signal: contactService.events)
            .flatMap(.Concat) { _ in self.fetchContactsFromService().liftError() }
        
        fetchContacts.apply(.None).start()
    }
    
    subscript(index: Int) -> ContactViewModel {
        return contactsShown.value[index]
    }
    
}

private extension ContactsAgendaViewModel {
    
    func fetchContactsFromService() -> SignalProducer<[ContactViewModel], ContactsFetchingError> {
        return _contactService.getContacts().map { contacts in
            contacts.map { ContactViewModel(contact: $0, contactService: self._contactService) }
        }
    }
    
    func filterContacts(contacts: [ContactViewModel]) -> [ContactViewModel] {
        switch self.activeFilter.value {
        case .Favourites: return contacts.filter { $0.favourited }
        default: return self._contacts.value
        }
    }
    
}