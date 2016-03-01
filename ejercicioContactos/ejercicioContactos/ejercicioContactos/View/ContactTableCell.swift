//
//  ContactTableCell.swift
//  ejercicioContactos
//
//  Created by Daniela Riesgo on 2/26/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Foundation
import UIKit


final class ContactTableCell : UITableViewCell {
    
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactPhoneLabel: UILabel!
    @IBOutlet weak var contactMailLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    var contact: ContactViewModel!
    var buttonAction: () -> () = {}
    
    
    func bindViewModel(contact: ContactViewModel, buttonAction: () -> ()) {
        self.buttonAction = buttonAction
        self.contact = contact
        self.contactImage.image = contact.image
        self.contactNameLabel.text = contact.name
        self.contactPhoneLabel.text = contact.phone
        self.contactMailLabel.text = contact.email
        self.favouriteButton.setTitle((contact.favourited) ? "Unfavourite" : "Favourite", forState: .Normal)
        self.favouriteButton.addTarget(self, action: "click:", forControlEvents: .TouchUpInside)
    }
    
    func click(sender: UIButton) {
        self.contact.favourited = !self.contact.favourited
        print("Llama a buttonAction")
        self.buttonAction()
    }
    
}
