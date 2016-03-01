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

class ContactViewModel : Object {
    
    dynamic var name : String
    dynamic var email : String
    dynamic var phone : String
    var favourited: Bool
    dynamic var image: UIImage
    dynamic var id: String
    
    required init() {
        self.id = " "
        self.name = " "
        self.email = " "
        self.phone = " "
        self.favourited = false
        self.image = UIImage(named: "noPicture")!
        super.init()
    }
    
    init(contact: Contact) {
        self.id = contact.id
        self.name = contact.name
        self.email = contact.email ?? " "
        self.phone = contact.phone ?? " "
        self.favourited = contact.favourited
        if let data = contact.image {
            self.image = UIImage(data: data)!
        } else {
            self.image = UIImage(named: "noPicture")!
        }
        super.init()
    }
    
    override static func ignoredProperties() -> [String] {
        return ["name", "email", "phone", "favourited", "image"]
    }
    
}
