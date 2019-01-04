//
//  TextFieldCollectionViewCell.swift
//  EmojiArt
//
//  Created by Cara Brennan on 8/28/18.
//  Copyright © 2018 Cara Brennan. All rights reserved.
//

import UIKit

class TextFieldCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField? {
        didSet {
            textField?.delegate = self
        }
    }

    var resignationHandler: (() -> Void)?
    func textFieldDidEndEditing(_ textField: UITextField) {
        resignationHandler?()
        print("When text filed resigns, resignationHandler set to something")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print ("resignsFirstResponder closes Keyboard")
        return true
    }
}
