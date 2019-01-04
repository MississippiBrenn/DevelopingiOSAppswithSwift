//
//  DocumentBrowserViewController.swift
//  EmoijArt
//
//  Created by Cara Brennan on 9/2/18.
//  Copyright © 2018 Cara Brennan. All rights reserved.
//

import UIKit


class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {

//4.1 configure documentVC
//6.1 configure for DocBVC giving to ViewDidLoad in EmAVC
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        //7.9.1 will set this to false, so that we can specify for iphone or ipad
        allowsDocumentCreation = false
        allowsPickingMultipleItems = false

        //7.9.2
        if UIDevice.current.userInterfaceIdiom == .pad {
//        6.33 assign template when loading view
        template = try? FileManager.default.url(
//            6.34 good place for things that are beind the scenes- appSD
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("Untitled.json")
        if template != nil {
//6.4 permits document creation based on if file was created or already exists, returns bool
            allowsDocumentCreation = FileManager.default.createFile(atPath: template!.path, contents: Data())
        }
        }
    }
    
    
    // MARK: UIDocumentBrowserViewControllerDelegate

//    6.31 create template
    var template: URL?
    //4.2 import handler to handle template
//    6.2 give url of blank document because someone is asking to create document
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
//6.3 call importHandler fromthe func and call it with a var temlplate which is a url and copy
        importHandler(template, .copy)
    }

//    6.5 called when people click on docs
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentURLs documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }

    //4.3 Called when it's time to open the document from different place-

    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
//6.5.2 put up your view controller to show this document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: Document Presentation
    //4.4 internal call for document to present mvc fort his document at this url 
    func presentDocument(at documentURL: URL) {
       //6.6 get storyboard and use it to get the vc that I want to present- vc i want to present is navigation controller that contains emvc- need to instantite nav vc so we give it a name in storyboard
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let documentVC = storyBoard.instantiateViewController(withIdentifier: "DocumentMVC")
//6.7 has doucmentvc  has vc that we need to set the document of
        if let emojiViewController = documentVC.contents as? EmojiArtViewController{
//            6.7.2 if we can get emavc then we can set it's documents to the doc it wants us to present
            emojiViewController.document = EmojiArtDocument(fileURL: documentURL)
        }
        present(documentVC, animated: true)

    }
}

