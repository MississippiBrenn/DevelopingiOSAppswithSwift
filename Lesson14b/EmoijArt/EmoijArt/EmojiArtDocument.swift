//
//  EmojiArtDocument.swift
//  EmoijArt
//
//  Created by Cara Brennan on 9/2/18.
//  Copyright © 2018 Cara Brennan. All rights reserved.
//

import UIKit


class EmojiArtDocument: UIDocument {
    //4.91 Need model passed to us in the document, any time we want model saved with data, give it to the document
    var emojiArt:EmojiArt?
    //7.1.2 set thumbnail
    var thumbnail: UIImage?

//    4.9 Any could be file wrapper, so does not return data
    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper
        return emojiArt?.json ?? Data()
    }
//    4.92 data passed to us, turn it inot emoji art
// 4.93 of type uti
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
        if let json = contents as? Data {
            emojiArt = EmojiArt(json: json)
        }
    }

//    7.0 return file attributes ie is hiddent etc as dictionary
    override func fileAttributesToWrite(to url: URL, for saveOperation: UIDocumentSaveOperation) throws -> [AnyHashable : Any] {
        var attributes = try super.fileAttributesToWrite(to: url, for: saveOperation)
        if let thumbnail = self.thumbnail {
            attributes[URLResourceKey.thumbnailDictionaryKey] =
                //7.1 if too small will use app icon
                [URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey: thumbnail]
        }
        return attributes
    }
}

