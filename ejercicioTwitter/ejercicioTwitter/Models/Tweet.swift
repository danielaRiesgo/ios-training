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
    let text: NSAttributedString
    let user: User
    
    var timeAgo: String {
        return createdAt.timeAgoSinceNow()
    }
    
    init(createdAt: NSDate, text: NSAttributedString, user: User) {
        self.createdAt = createdAt
        self.text = text
        self.user = user
    }
    
}
