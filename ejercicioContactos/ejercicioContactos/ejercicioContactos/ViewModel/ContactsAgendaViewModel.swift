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
    private let _contactService : ContactServiceType
    private let _persistenceService : PersistenceServiceType
    
    private let _contacts = MutableProperty<[ContactViewModel]>([])
    private let _contactsShown = MutableProperty<[ContactViewModel]>([])
    
    var favourites : Bool = false
    let contactsShown : AnyProperty<[ContactViewModel]>
    var changeList: Action<Bool, [ContactViewModel], NoError>
    var updateContacts: Action<AnyObject?, [ContactViewModel], ContactsFetchingError>
    var updateFavourites: Action<AnyObject?, [ContactViewModel], NoError>
    
//    private var _foo: Action<AnyObject?, [ContactViewModel], NoError>!
//    var foo: Action<AnyObject?, [ContactViewModel], NoError> {
//        return _foo
//    }
//    
//    private(set) var bar: Action<AnyObject?, [ContactViewModel], NoError>!
//    
    
    var contactsCount : Int {
        return _contactsShown.value.count
    }
    
    init(contactService: ContactServiceType = ContactService(), persistenceService : PersistenceServiceType = PersistenceService()) {
        self._contactService = contactService
        self._persistenceService = persistenceService
        
        self.contactsShown = AnyProperty(self._contactsShown)
        
        self.changeList = Action { _ in return SignalProducer(value: []) }
        self.updateContacts = Action { _ in return SignalProducer(value: []) }
        self.updateFavourites = Action { _ in return SignalProducer(value: []) }
        
        self.changeList = Action { showFavourites in
            self.favourites = showFavourites
            let value: [ContactViewModel]
            if showFavourites {
                value = self._contacts.value.filter { $0.favourited }
            } else {
                value = self._contacts.value
            }
            return SignalProducer(value: value)
        }
        self.updateContacts = Action { _ in
            //print("Llama a updateContacts")
            return contactService.getContacts().observeOn(UIScheduler())
                .map {self._persistenceService.unpersistFavouritesInContacts( $0.map {contact in ContactViewModel(contact: contact)} )}
                .on(completed: { self.changeList.apply(self.favourites).start() })
        }
        self.updateFavourites = Action { _ in
            //print("En update favourties")
            let value: [ContactViewModel]
            if self.favourites {
                value = self._contacts.value.filter { $0.favourited }
            } else {
                value = self._contacts.value
            }
            return SignalProducer(value: value)
        }
        _contacts <~ self.updateContacts.values
        _contactsShown <~ self.changeList.values
        _contactsShown <~ self.updateFavourites.values
    }
    
    func persist () {
        self._persistenceService.persistFavourites(self._contacts.value)
    }
    
    subscript(index: Int) -> ContactViewModel {
        return _contactsShown.value[index]
    }
    
}
