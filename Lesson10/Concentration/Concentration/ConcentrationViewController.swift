//
//  ViewController.swift
//  Concentration
//
//  Created by Cara Brennan on 8/22/18.
//  Copyright © 2018 Cara Brennan. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {

    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)

    var numberOfPairsOfCards :Int {
        return (cardButtons.count+1) / 2

    }

    private(set) var flipCount: Int = 0 {
        didSet {
            updateFlipCountLabel()
        }
    }

    private func updateFlipCountLabel() {
        let attributes:[NSAttributedStringKey:Any] =
            [.strokeWidth : 5.0,
             .strokeColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(
            string: traitCollection.verticalSizeClass == .compact ? "Flips: \n\(flipCount)" : "Flips: \(flipCount)",
            attributes: attributes)
        flipCountLabel.attributedText = attributedString

    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
     super.traitCollectionDidChange(previousTraitCollection)
        updateFlipCountLabel()
    }

    @IBOutlet private weak var flipCountLabel: UILabel!{
        didSet {
            updateFlipCountLabel()
        }
    }

    @IBOutlet private var cardButtons: [UIButton]!

    private var visibleCardButtons: [UIButton]! {
        return cardButtons?.filter{ !$0.superview!.isHidden }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViewFromModel()
    }

    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = visibleCardButtons.index(of: sender){
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }else {
            print ("chosen card not in cardButtons")
        }
    }
    func updateViewFromModel(){
        if visibleCardButtons != nil {
        for index in visibleCardButtons.indices {
            let button = visibleCardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for:UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

            }else {
                button.setTitle("", for:UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            }
            }
        }
    }

    var theme: String? {
        didSet{
            emojiChoices = theme ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }

    
    private var emojiChoices = "🦇😱🙀😈🎃👻🍭🍬"

    private var emoji = [Card: String]()

    func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0  {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }

        return emoji[card] ?? "?"
    }
}

extension Int{
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }else{
            return 0
        }
    }
}

