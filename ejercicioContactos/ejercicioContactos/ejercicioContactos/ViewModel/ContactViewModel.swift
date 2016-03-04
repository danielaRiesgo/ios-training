//
//  ContactViewModel.swift
//  ejercicioContactos
//
//  Created by Daniela Riesgo on 2/29/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

struct ContactViewModel {
    
    private let _contact : Contact
    private let _contactService : ContactServiceType
    let image: UIImage
    
    var name : String {
        return self._contact.name
    }
    var email : String {
        return self._contact.email ?? " "
    }
    var phone : String {
        return self._contact.phone ?? " "
    }
    var favourited: Bool {
        return self._contact.favourited
    }
    var id: String {
        return self._contact.id
    }
    
    init(contact: Contact, contactService: ContactServiceType) {
        self._contact = contact
        self._contactService = contactService
        if let data = contact.image {
            self.image = UIImage(data: data)!
        } else {
            self.image = UIImage(named: "noPicture")!
        }
    }
    
    func changeFavouriteState() {
        self._contactService.updateFavourite(self._contact, favourite: !self.favourited).start()
    }
    
}
