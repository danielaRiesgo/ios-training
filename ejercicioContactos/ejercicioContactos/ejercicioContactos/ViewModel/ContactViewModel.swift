//
//  ContactViewModel.swift
//  ejercicioContactos
//
//  Created by Daniela Riesgo on 2/29/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Foundation
import UIKit

class ContactViewModel {
    
    let name : String
    let email : String
    let phone : String
    var favourited: Bool
    let image: UIImage
    
    init(contact: Contact) {
        self.name = contact.name
        self.email = contact.email
        self.phone = contact.phone
        self.favourited = contact.favourited
        self.image = UIImage(named: "noPicture")!
    }
    
}
