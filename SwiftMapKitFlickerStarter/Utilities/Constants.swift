//
//  Constants.swift
//  SwiftMapKitFlickerStarter
//
//  Created by MacBook on 1/22/19.
//  Copyright © 2019 Ahil. All rights reserved.
//

import Foundation

func flickrUrl(forApiKey key: String, withAnnotation annotation: DroppablePin, andNumberOfPhotos number: Int) -> String {
    return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&lat=\(annotation.coordinate.latitude)&lon=\(annotation.coordinate.longitude)&radius=1&radius_units=mi&per_page=\(number)&format=json&nojsoncallback=1"
}

