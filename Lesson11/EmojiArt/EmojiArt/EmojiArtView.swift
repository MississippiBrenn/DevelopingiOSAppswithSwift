//
//  EmojiArtView.swift
//  EmojiArt
//
//  Created by Cara Brennan on 8/25/18.
//  Copyright © 2018 Cara Brennan. All rights reserved.
//

import UIKit

class EmojiArtView: UIView {

    var backgroundImage: UIImage? { didSet {setNeedsDisplay() } }

    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }


}
