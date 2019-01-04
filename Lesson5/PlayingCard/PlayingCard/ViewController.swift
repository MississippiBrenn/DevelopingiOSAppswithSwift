//
//  ViewController.swift
//  PlayingCard
//
//  Created by Cara Brennan on 8/23/18.
//  Copyright © 2018 Cara Brennan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var deck = PlayingCardDeck()

    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 1...10 {
            if let card = deck.draw(){
                print ("\(card)")
            }
        }

    }

}
