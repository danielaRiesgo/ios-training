//
//  ContactsAgendaViewModel.swift
//  ejercicioContactos
//
//  Created by Daniela Riesgo on 2/29/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Foundation
import ReactiveCocoa

final class ContactsAgendaViewModel {
    private let _contactService : ContactServiceType
    private let _contacts = MutableProperty<[ContactViewModel]>([])
    private let _contactsShown = MutableProperty<[ContactViewModel]>([])
    private var _favourites : Bool = false
    
    let contactsShown : AnyProperty<[ContactViewModel]>
    var changeList: Action<Bool, [ContactViewModel], NSError>
    var updateContacts: Action<AnyObject?, [ContactViewModel], NSError>
    var updateFavourites: Action<AnyObject?, [ContactViewModel], NSError>
    
    var contactsCount : Int {
        return _contactsShown.value.count
    }
    
    init(contactService: ContactServiceType = ContactService()) {
        self._contactService = contactService
        self.contactsShown = AnyProperty(self._contactsShown)
        
        self.changeList = Action { _ in return SignalProducer(value: []) }
        self.updateContacts = Action { _ in return SignalProducer(value: []) }
        self.updateFavourites = Action { _ in return SignalProducer(value: []) }
        
        self.changeList = Action { showFavourites in
            self._favourites = showFavourites
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
            return SignalProducer(value: contactService.getContacts().map { ContactViewModel(contact: $0) })
                .on(completed: {self.changeList.apply(self._favourites).start()})
        }
        self.updateFavourites = Action { _ in
            //print("En update favourties")
            let value: [ContactViewModel]
            if self._favourites {
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
    
    subscript(index: Int) -> ContactViewModel {
        return _contactsShown.value[index]
    }
    
}
