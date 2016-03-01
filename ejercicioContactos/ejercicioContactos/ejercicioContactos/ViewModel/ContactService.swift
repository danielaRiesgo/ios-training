//
//  ContactService.swift
//  ejercicioContactos
//
//  Created by Daniela Riesgo on 2/29/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Foundation

protocol ContactServiceType {
    
    func getContacts() -> [Contact]
    
}

class ContactService : ContactServiceType {
    
    func getContacts() -> [Contact] {
        print("Entra a pedir contactos")
        return [ Contact(name: "Contacto 1", email: "email@mail.com", phoneNumber: " ", favourite: true), Contact(name: "Contacto 2", email: "email2@mail.com", phoneNumber: "48362846"), Contact(name: "Contacto 3", email: " ", phoneNumber: "48362846"), Contact(name: "Contacto 4", email: "email4@mail.com", phoneNumber: " "), Contact(name: "Contacto 5", email: "email5@mail.com", phoneNumber: "45902846", favourite: true), Contact(name: "Contacto 6", email: "email6@mail.com", phoneNumber: "45902846", favourite: true) ]
    }
    
}