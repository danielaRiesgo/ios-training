//
//  User.swift
//  ejercicioTwitter
//
//  Created by Daniela Riesgo on 2/15/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Foundation

struct User {
    
    let name: String
    let profileImageURL: NSURL
    
    init(name: String, profileImageURL: NSURL) {
        self.name = name
        self.profileImageURL = profileImageURL
    }

}
