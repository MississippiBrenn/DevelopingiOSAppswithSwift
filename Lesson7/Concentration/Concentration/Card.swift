//
//  Card.swift
//  Concentration
//
//  Created by Cara Brennan on 8/22/18.
//  Copyright © 2018 Cara Brennan. All rights reserved.
//

import Foundation

struct Card: Hashable {

    var hashValue: Int {return identifier}

    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    var isFaceUp = false
    var isMatched = false
    private var identifier: Int

    static var identifierFactory = 0

    static func getUniqueIdentifier() -> Int {
        Card.identifierFactory += 1
        return Card.identifierFactory
    }

    init(){
        self.identifier = Card.getUniqueIdentifier()
    }
}
