//
//  Contact.swift
//  ejercicioContactos
//
//  Created by Daniela Riesgo on 2/29/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Foundation

struct Contact {
    
    let name : String
    let email : String?
    let phone : String?
    let favourited: Bool
    let image: NSData?
    let id: String

    init(id: String, name: String, email: String?, phoneNumber: String?, imageData: NSData?, favourite: Bool = false) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phoneNumber
        self.favourited = favourite
        self.image = imageData
    }

    
}