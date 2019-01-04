//
//  ViewController.swift
//  Concentration
//
//  Created by Cara Brennan on 8/22/18.
//  Copyright © 2018 Cara Brennan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var flipCount: Int = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }

    @IBOutlet weak var flipCountLabel: UILabel!

    @IBOutlet var cardButtons: [UIButton]!

    var emojiChoices: Array<String> = ["🎃","👻","🎃", "👻", "🎃", "👻"]

    @IBAction func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender){
            flipCard(withEmoji: emojiChoices[cardNumber], on: sender)
        }else {
            print ("chosen card not in cardButtons")
        }
    }

    func flipCard(withEmoji emoji: String, on button: UIButton){
        if button.currentTitle == emoji {
            button.setTitle("", for:UIControlState.normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        } else {
            button.setTitle(emoji, for:UIControlState.normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }

}

