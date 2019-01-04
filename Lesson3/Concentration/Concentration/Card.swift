//
//  Card.swift
//  Concentration
//
//  Created by Cara Brennan on 8/22/18.
//  Copyright © 2018 Cara Brennan. All rights reserved.
//

import Foundation

struct Card{

    var isFaceUp = false
    var isMatched = false
    var identifier: Int

    static var identifierFactory = 0

    static func getUniqueIdentifier() -> Int {
        Card.identifierFactory += 1
        return Card.identifierFactory
    }

    init(){
        self.identifier = Card.getUniqueIdentifier()
    }
}
