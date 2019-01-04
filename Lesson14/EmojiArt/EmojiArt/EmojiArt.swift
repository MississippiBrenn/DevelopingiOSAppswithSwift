//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Cara Brennan on 8/31/18.
//  Copyright © 2018 Cara Brennan. All rights reserved.
//

import Foundation

//this is codable and is JSON
struct EmojiArt: Codable
{
    var url: URL
    var emojis = [EmojiInfo]()

    //not inherently codable, need to specify
    struct EmojiInfo: Codable {
        let x: Int
        let y: Int
        let text: String
        let size: Int
    }

    //30.6 initializer that creates emojiArt from jsonData to add to create view so that view is not blank
    //30.7 only initializes if it is valid json
    init?(json: Data) {
        if let newValue  = try? JSONDecoder().decode(EmojiArt.self, from: json){
            self = newValue
        } else {
            return nil
        }

    }

    //JSON version - will work because all types in class are codable
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }

    init(url: URL, emojis: [EmojiInfo]) {
        self.url = url
        self.emojis = emojis
    }
}
