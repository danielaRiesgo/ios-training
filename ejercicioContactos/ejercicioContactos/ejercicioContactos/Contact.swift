//
//  Contact.swift
//  ejercicioContactos
//
//  Created by Daniela Riesgo on 2/29/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Foundation
import RealmSwift

final class Contact : Object {
    
    dynamic var id: String
    dynamic var name : String
    dynamic var email : String?
    dynamic var phone : String?
    var favourited: Bool
    dynamic var image: NSData?

    init(id: String, name: String, email: String?, phoneNumber: String?, imageData: NSData?, favourite: Bool = false) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phoneNumber
        self.favourited = favourite
        self.image = imageData
        
        super.init()
    }
    
    required init() {
        self.id = " "
        self.name = " "
        self.email = .None
        self.phone = .None
        self.favourited = false
        self.image = .None
        super.init()
    }
    
    override static func ignoredProperties() -> [String] {
        return ["name", "email", "phone", "favourited", "image"]
    }
    
}