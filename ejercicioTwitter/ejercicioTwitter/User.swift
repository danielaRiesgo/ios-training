//
//  User.swift
//  ejercicioTwitter
//
//  Created by Daniela Riesgo on 2/15/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import UIKit

struct User {
    
    let name: String
    let profileImageURL: NSURL
    
    init(name: String, profileImageURL: NSURL) {
        self.name = name
        self.profileImageURL = profileImageURL
    }

    func downloadProfileImage(URLSession: NSURLSession = NSURLSession.sharedSession(), completion: (NSData?, NSError?) -> ()) -> NSURLSessionDataTask {
        let task = URLSession.dataTaskWithRequest(NSURLRequest(URL: profileImageURL)) { data, _, error in
            completion(data, error)
        }
        task.resume()
        return task
    }

}
