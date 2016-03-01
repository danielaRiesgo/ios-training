//
//  PersistenceService.swift
//  ejercicioContactos
//
//  Created by Daniela Riesgo on 3/1/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Foundation
import RealmSwift

protocol PersistenceServiceType {
    
    func persistFavourites(contacts: [ContactViewModel])
    func unpersistFavouritesInContacts(contacts: [ContactViewModel]) -> [ContactViewModel]
    
}

class PersistenceService : PersistenceServiceType {

    let realm : Realm
    
    init(path: String = "favouritesDatabase") {
        var config = Realm.Configuration()
        
        config.path = NSURL.fileURLWithPath(config.path!)
            .URLByDeletingLastPathComponent?
            .URLByAppendingPathComponent("\(path).realm")
            .path
        //print("Path: \(config.path)")
        
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
        self.realm = try! Realm()
        //if (self.realm.isEmpty) { print("Está vacía") }
    }
    
    func persistFavourites(contacts: [ContactViewModel]) {
        for contact in contacts {
            if contact.favourited {
                do { try realm.write { realm.add(contact) }
                } catch { error
                    print("Error al escribir el contacto de id \(contact.id): \(error)")
                }
            }
        }
    }
    
    func unpersistFavouritesInContacts(contacts: [ContactViewModel]) -> [ContactViewModel] {
        let favourites = self.realm.objects(ContactViewModel)
        let idsArray = contacts.map { $0.id }
        for favourite in favourites {
            if let index = idsArray.indexOf(favourite.id) {
                contacts[index].favourited = true
            } else {
                do { try realm.write { realm.delete(favourite) }
                } catch {
                    print("Error al borrar el contacto de Realm con id \(favourite.id)")
                }
            }
        }
        return contacts
    }
    
}