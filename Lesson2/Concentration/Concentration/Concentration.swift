//
//  Concentration.swift
//  Concentration
//
//  Created by Cara Brennan on 8/22/18.
//  Copyright © 2018 Cara Brennan. All rights reserved.
//

import Foundation

struct Concentration {

   private(set) let cards = [Card]()

    private var indexOfOneAndOnlyFaceUpCard : Int? {
        get{
            var foundIndex: Int?
            for index in cards.indices {
                if cards[incdex].isFaceUp {
                    if foundIndex == nil {
                        foundINdex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }

   mutating func chooseCard(at index: Int){
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                cards[matchIndex].isMatched = true
                cards[index].isMatched = true
            }
            cards[index].isFaceUp = true
        } else{
            indexOfOneAndOnlyFaceUpCard = index
        }

    }
    }

    init(numberOfPairsOfCards: Int){
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): you must have at least one pair of cards")
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
