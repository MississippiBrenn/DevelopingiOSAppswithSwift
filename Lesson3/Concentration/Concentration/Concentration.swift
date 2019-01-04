//
//  Concentration.swift
//  Concentration
//
//  Created by Cara Brennan on 8/22/18.
//  Copyright © 2018 Cara Brennan. All rights reserved.
//

import Foundation

class Concentration {

    var cards = [Card]()
    var indexOfOneAndOnlyFaceUpCard : Int?

    func chooseCard(at index: Int){
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                cards[matchIndex].isMatched = true
                cards[index].isMatched = true
            }
            cards[index].isFaceUp = true
            indexOfOneAndOnlyFaceUpCard = nil
        } else{
            for flipDownIndex in cards.indices {
                cards[flipDownIndex].isFaceUp = false
            }
            cards[index].isFaceUp = true
            indexOfOneAndOnlyFaceUpCard = index
        }

    }
    }

    init(numberOfPairsOfCards: Int){
        for _ in  1...numberOfPairsOfCards{
            let card = Card()
            cards += [card, card]
        }
        self.shuffle()

    }

    func shuffle() {
        let c = cards.count
        guard c > 1 else { return }

        for (firstUnshuffled, unshuffledCount) in zip(cards.indices, stride(from: c, to: 1, by: -1)) {
            // Change `Int` in the next line to `IndexDistance` in < Swift 4.1
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = cards.index(firstUnshuffled, offsetBy: d)
            cards.swapAt(firstUnshuffled, i)
        }
    }
}
