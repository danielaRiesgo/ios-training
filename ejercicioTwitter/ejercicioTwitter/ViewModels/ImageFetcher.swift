//
//  ImageFetcher.swift
//  ejercicioTwitter
//
//  Created by Daniela Riesgo on 2/17/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//


import Foundation

protocol ImageFetcherType {
    
    func downloadProfileImage(url: NSURL, URLSession: NSURLSession, completion: (NSData?, NSError?) -> ()) -> NSURLSessionDataTask
    
}


class ImageFetcher : ImageFetcherType {

    func downloadProfileImage(url: NSURL, URLSession: NSURLSession = NSURLSession.sharedSession(), completion: (NSData?, NSError?) -> ()) -> NSURLSessionDataTask {
        let task = URLSession.dataTaskWithRequest(NSURLRequest(URL: url)) { data, _, error in
            completion(data, error)
        }
        task.resume()
        return task
    }
    
}
