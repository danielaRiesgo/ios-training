//
//  ImageFetcher.swift
//  ejercicioTwitter
//
//  Created by Daniela Riesgo on 2/17/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//


import Foundation
import ReactiveCocoa

enum ImageFetcherError: ErrorType {
    
    case FetchError(NSError)
    case InvalidImageData
    
}

protocol ImageFetcherType {
    
    func fetchImage(imageURL: NSURL) -> SignalProducer<UIImage, ImageFetcherError>
    
}


final class ImageFetcher : ImageFetcherType {

    private let _URLSession: NSURLSession
    
    init(URLSession: NSURLSession = NSURLSession.sharedSession()) {
        _URLSession = URLSession
    }
    
    func fetchImage(imageURL: NSURL) -> SignalProducer<UIImage, ImageFetcherError> {
        return _URLSession.rac_dataWithRequest(NSURLRequest(URL: imageURL))
            .mapError { .FetchError($0) }
            .flatMap(.Concat) { data, _ -> SignalProducer<UIImage, ImageFetcherError> in
                UIImage(data: data).map { SignalProducer(value: $0) } ?? SignalProducer(error: .InvalidImageData)
            }
    }
    
}
