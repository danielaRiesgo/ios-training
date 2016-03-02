//
//  PersistenceService.swift
//  ejercicioContactos
//
//  Created by Daniela Riesgo on 3/1/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveCocoa


enum PersistingError : ErrorType {
    case AddFavouriteError(Contact)
    case DeleteFavouriteError(Contact)
}

protocol PersistenceServiceType {
    
    /* Return an array with the ids (strings) of the favourited contacts */
    func getFavourites() -> [String]
    func updateFavourite(contact: Contact, newFavouritedState: Bool) -> SignalProducer<Contact, PersistingError>
    
}

final class PersistenceService : PersistenceServiceType {

    let realm : Realm
    
    init(path: String = "favouritesDatabase") {
        var config = Realm.Configuration()
        
        config.path = NSURL.fileURLWithPath(config.path!)
            .URLByDeletingLastPathComponent?
            .URLByAppendingPathComponent("\(path).realm")
            .path
        //print("Path: \(config.path)")
        
        Realm.Configuration.defaultConfiguration = config
        self.realm = try! Realm()
        //if (self.realm.isEmpty) { print("Está vacía") }
    }
    
    func getFavourites() -> [String] {
        let favourites = self.realm.objects(Contact)    // Parece que nunca falla
        return favourites.map { $0.id }
    }
    
    func updateFavourite(contact: Contact, newFavouritedState: Bool) -> SignalProducer<Contact, PersistingError> {
        let newContact = Contact(id: contact.id, name: contact.name, email: contact.email, phoneNumber: contact.phone, imageData: contact.image, favourite: newFavouritedState)
        if (newFavouritedState == true) {
            do { try realm.write { realm.add(newContact) }
            } catch { error
                //print("Error al escribir el contacto de id \(contact.id): \(error)")
                return SignalProducer(error: .AddFavouriteError(newContact))
            }
        } else {
            let persistedContact = realm.objects(Contact).filter("id == \(contact.id)").first!
            do { try realm.write { realm.delete(persistedContact) }
            } catch { error
                //print("Error al borrar el contacto de id \(contact.id): \(error)")
                return SignalProducer(error: .DeleteFavouriteError(newContact))
            }
        }
        return SignalProducer(value: newContact)
    }
    
}