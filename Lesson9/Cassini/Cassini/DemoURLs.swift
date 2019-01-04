//
//  DemoURLs.swift
//  Cassini
//
//  Created by Cara Brennan on 8/22/18.
//  Copyright © 2018 Cara Brennan. All rights reserved.
//

import Foundation

internal struct DemoURLs {

    static let stanford = Bundle.main.url(forResource: "oval", withExtension: "jpg")

    static var NASA: Dictionary<String,URL> = {
        let NASAURLStrings = [
            "Cassini" : "https://espnfivethirtyeight.files.wordpress.com/2017/09/pia21641-large.jpg",
            "Earth" : "https://www.nasa.gov/sites/default/files/thumbnails/image/annotated_earth-moon_from_saturn_1920x1080.jpg",
            "Saturn" : "https://d1o50x50snmhul.cloudfront.net/wp-content/uploads/2017/09/15150440/1.36837350800_8e2c553cd7_k.jpg"
        ]
        var urls = Dictionary<String,URL>()
        for (key, value) in NASAURLStrings {
            urls[key] = URL(string: value)
        }
        return urls
    }()
}
