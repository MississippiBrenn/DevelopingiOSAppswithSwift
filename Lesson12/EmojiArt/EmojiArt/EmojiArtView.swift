//
//  EmojiArtView.swift
//  EmojiArt
//
//  Created by Cara Brennan on 8/25/18.
//  Copyright © 2018 Cara Brennan. All rights reserved.
//

import UIKit

class EmojiArtView: UIView, UIDropInteractionDelegate {
    override init(frame:CGRect){
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        addInteraction(UIDropInteraction(delegate: self))
       //trigger interaction where EmojiArtView is UI DropInteractionDelegate
    }

    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool{
        return session.canLoadObjects(ofClass: NSAttributedString.self)
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal{
        return UIDropProposal(operation: .copy)
    }

    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: NSAttributedString.self) { providers in
            let dropPoint = session.location(in: self)
            for attributedString in providers as? [NSAttributedString] ?? []  {
                print (attributedString)
            self.addLabel(with: attributedString, centeredAt: dropPoint )
            }
        }
    }


    private func addLabel(with attributedString: NSAttributedString, centeredAt point: CGPoint){
        let label = UILabel()
        label.backgroundColor = .clear
        label.attributedText = attributedString
        label.sizeToFit()
        label.center = point
        addEmojiArtGestureRecognizers(to: label)
        addSubview(label)
    }

    var backgroundImage: UIImage? { didSet {setNeedsDisplay() } }

    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }


}
