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
    func updateFavourite(newContact: Contact) -> SignalProducer<Contact, PersistingError>
    
}

final class PersistenceService : PersistenceServiceType {

    let realm : Realm
    var favourites: [String] = []
    
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
        /*let favourites = self.realm.objects(ContactRecord)    // Parece que nunca falla
        return favourites.map { $0.id }*/
        return favourites
    }
    
    func updateFavourite(newContact: Contact) -> SignalProducer<Contact, PersistingError> {
        if (newContact.favourited == true) {
            favourites.append(newContact.id)
            /*do { try realm.write { realm.add(ContactRecord(newContact)) }
            } catch { error
                //print("Error al escribir el contacto de id \(newContact.id): \(error)")
                return SignalProducer(error: .AddFavouriteError(newContact))
            }*/
        } else {
            favourites.removeAtIndex(favourites.indexOf(newContact.id)!)
            /*let persistedContactRecord = realm.objects(ContactRecord).filter("id == \(newContact.id)").first!
            do { try realm.write { realm.delete(persistedContactRecord) }
            } catch { error
                //print("Error al borrar el contacto de id \(newContact.id): \(error)")
                return SignalProducer(error: .DeleteFavouriteError(newContact))
            }*/
        }
        return SignalProducer(value: newContact).observeOn(UIScheduler())
    }
    
}


final class ContactRecord : Object {
    
    dynamic var id: String
    var favourited: Bool
    
    convenience init(contact: Contact) {
        self.init()
        self.id = contact.id
        self.favourited = contact.favourited
    }
    
    required init() {
        self.id = ""
        self.favourited = true
        super.init()
    }
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["favourited"]
    }
    
}

