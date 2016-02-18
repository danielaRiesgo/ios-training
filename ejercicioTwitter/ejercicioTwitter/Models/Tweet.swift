//
//  Tweet.swift
//  ejercicioTwitter
//
//  Created by Daniela Riesgo on 2/15/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import DateTools

struct Tweet {

    let createdAt: NSDate
    let text: String
    let user: User
    let userEntities: [TweetEntity]
        
    init(createdAt: NSDate, text: String, user: User, userEntities: [TweetEntity]) {
        self.createdAt = createdAt
        self.text = text
        self.user = user
        self.userEntities = userEntities
    }
    
}
