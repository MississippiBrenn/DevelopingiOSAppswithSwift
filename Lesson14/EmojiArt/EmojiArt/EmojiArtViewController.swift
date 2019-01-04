//
//  EmojiArtViewController.swift
//  EmojiArt
//
//  Created by Cara Brennan on 8/25/18.
//  Copyright © 2018 Cara Brennan. All rights reserved.
//
//Post lecture
//delegation so we don't have to "save" button
// add new type emoji art - add in settings and change empty template to be untitled.emoji art 



import UIKit

extension EmojiArt.EmojiInfo {
    //label initializer
    init?(label: UILabel) {
        if let attributedText = label.attributedText, let font = attributedText.font {
            x = Int(label.center.x)
            y = Int(label.center.y)
            text = attributedText.string
            size = Int(font.pointSize)
        } else {
            //failable initializer
            return nil
        }
    }
}

class EmojiArtViewController: UIViewController, UIDropInteractionDelegate, UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDragDelegate, UICollectionViewDropDelegate {

    //MARK: - Model

    //model and UI in sync, can set and get this model
    //persistent by being codable, we will use JSON as file format
    var emojiArt: EmojiArt? {
        get {
            if let url = emojiArtBackgroundImage.url{
                let emojis = emojiArtView.subviews.flatMap { $0 as? UILabel }.flatMap { EmojiArt.EmojiInfo(label: $0)}
                return EmojiArt(url: url, emojis:emojis)
            }
            return nil
        }
        set {
            //clearing out old
            emojiArtBackgroundImage = (nil, nil)
            emojiArtView.subviews.flatMap { $0 as? UILabel}.forEach { $0.removeFromSuperview() }
            //putting in new
            if let url = newValue?.url {
                imageFetcher = ImageFetcher(fetch: url) {(url, image) in
                    DispatchQueue.main.async {
                        self.emojiArtBackgroundImage = (url, image)
                        // add all labels for emojis
                        newValue?.emojis.forEach {
                            let attributedText = $0.text.attributedString(withTextStyle: .body, ofSize: CGFloat($0.size))
                            //ask emojiArtView to add Label for each one
                            self.emojiArtView.addLabel(with: attributedText, centeredAt: CGPoint(x: $0.x, y: $0.y))
                        }
                    }
                }
            }

        }
    }

    //5.3 set document in mvc and it appears
    var document: EmojiArtDocument?

    //5.1 replace func save - where we were accessing the file system directly because now we have a view controller that does the work for us
    //print model out on the console
    //    5.7 documenting change happens/tracked in view-knows when we've resized or whatever but it can't talk balk to controller atm, so we put tracking to talk back to controller using delegation where we have emoji artview delegate- don't have explicit save buttons it should call automatically

    @IBAction func save(_ sender: UIBarButtonItem? = nil) {
        //5.6 we have autosave, all we have to do is say that something is changed and it saves
        //        5.6.1 tell document to look at model
        document?.emojiArt = emojiArt
        //        5.6.2 say change has happened if document is not nil
        if document?.emojiArt != nil {
            document?.updateChangeCount(.done)
        }
    }

    //6.8 vc that want's to close dismisses itself
    @IBAction func close(_ sender: UIBarButtonItem) {
        //        5.8 save when you close as we do not have automatic change tracking
        save()
        //        7.2 snapthot is var in utilities
        if document?.emojiArt != nil {
            document?.thumbnail = emojiArtView.snapshot
        }
        //        6.81 closses itslef, completion handler after dismiss is true closes
        dismiss(animated: true) {
            self.document?.close()
        }
    }


    //5.2 replace func vWA - where we were accessing the file system directly because now we have a view controller that does the work for us
    //print model out on the console
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //5.4 open document first with completion handler
        document?.open { success in
            if success {
                self.title = self.document?.localizedName
                //5.5 set model into the mode that the doc was able to get by opening that file, setting and getting
                self.emojiArt = self.document?.emojiArt
            }
        }
    }
    //    6.0 removing this, as we are going to get the view from whatever the documentViewBrowser wants it to be
    //// 5.9 load view of document, set document to an emojiArtDoc, document only has one initializer, the url, should load untitled.json on launch
    //    func viewdidLoad() {
    //    super.viewDidLoad()
    //        if let url = try? FileManager.default.url(
    //            for: .documentDirectory,
    //            in: .userDomainMask,
    //            appropriateFor: nil,
    //            create:true
    //            ).appendingPathComponent("Untitled.json") {
    //            document = EmojiArtDocument(fileURL: url)
    //        }
    //
    //    }
    //MARK: - Storyboard

    @IBOutlet weak var dropZone: UIView! {
        didSet {
            print ("did dropZone")
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }

    var emojiArtView = EmojiArtView()

    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 5.0
            scrollView.delegate = self
            scrollView.addSubview(emojiArtView)
        }
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {

        scrollViewHeight.constant = scrollView.contentSize.height
        scrollViewWidth.constant = scrollView.contentSize.width
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return emojiArtView
    }


    private var _emojiArtBackgrounImageURL: URL?

    var emojiArtBackgroundImage: (url: URL?, image: UIImage?)
    {
        get{
            return (_emojiArtBackgrounImageURL, emojiArtView.backgroundImage)
        }
        set {
            _emojiArtBackgrounImageURL = newValue.url
            scrollView?.zoomScale = 1.0
            emojiArtView.backgroundImage = newValue.image
            let size = newValue.image?.size ?? CGSize.zero
            emojiArtView.frame = CGRect(origin: CGPoint.zero, size: size)
            scrollView?.contentSize = size
            scrollViewHeight?.constant = size.height
            scrollViewWidth?.constant = size.width
            if let dropZone = self.dropZone, size.width > 0, size.height > 0 {
                scrollView?.zoomScale = max(dropZone.bounds.size.width / size.width, dropZone.bounds.size.height / size.height)
            }
        }
    }
    var emojis = "😀🎁✈️🎱🍎🐶🐝☕️🎼🚲♣️👻☎️".map { String($0) }

    @IBOutlet weak var emojiCollectionView: UICollectionView! {
        didSet {
            emojiCollectionView.dataSource = self
            emojiCollectionView.delegate = self
            emojiCollectionView.dragDelegate = self
            emojiCollectionView.dropDelegate = self
            //7.9.4 so that we can drag in iphone, false by default
            emojiCollectionView.dragInteractionEnabled = true
        }
    }

    private var addingEmoji = false

    @IBAction func addEmoji(){
        //plus button uses target action to controller
        addingEmoji = true
        emojiCollectionView.reloadSections(IndexSet(integer: 0))
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return emojis.count
        default: return 0
        }
    }

    //accessibiltiy scaling
    private var font: UIFont {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(64.0))
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath)
            if let emojiCell = cell as? EmojiCollectionViewCell {
                let text = NSAttributedString(string: emojis[indexPath.item], attributes: [.font:font])
                emojiCell.label.attributedText = text
            }
            return cell
        }else if addingEmoji {
            //double memory cycle
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiInputCell", for: indexPath)
            if let inputCell = cell as? TextFieldCollectionViewCell {
                inputCell.resignationHandler = { [weak self, unowned inputCell] in
                    if let text = inputCell.textField?.text {
                        self?.emojis = (text.map {String($0) } + self!.emojis).uniquified
                    }
                    self?.addingEmoji = false
                    self?.emojiCollectionView.reloadData()
                }
            }
            print("adding EmojiInputCell cell")
            return cell
        } else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddEmojiButtonCell", for: indexPath)
            print("adding EmojiInputButton cell")
            return cell
        }

    }

    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if addingEmoji && indexPath.section == 0 {
            return CGSize(width: 300, height: 80)
        }else {
            return CGSize(width: 80, height: 80)
        }
    }

    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let inputCell = cell as? TextFieldCollectionViewCell {
            //            print ("keyboard comes up with cell")
            inputCell.textField?.becomeFirstResponder()
        }
    }

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        //        print ("emoji 1.items for begining session of dragsession")
        return dragItems(at:indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session:UIDragSession, at indexPath:IndexPath, point: CGPoint) -> [UIDragItem] {
        //        print("emoji 2b.items for adding to collectionview")
        return dragItems(at: indexPath)
    }

    private func dragItems(at indexPath: IndexPath)-> [UIDragItem]{
        if !addingEmoji, let attributedString = (emojiCollectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell)?.label.attributedText {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: attributedString))
            dragItem.localObject = attributedString
            //            print ("emoji 2. dragItems if is emojicollection view cell")
            return [dragItem]

        }else {
            return []
        }

    }

    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        print("background image 1.canHandle UIDropSession ; emoji 4. canHandle UIDropSession")
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        //        print("background image 2.sessionDidUpdate UIDropSession")
        return UIDropProposal(operation: .copy)
    }

    var imageFetcher: ImageFetcher!

    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        imageFetcher = ImageFetcher() { (url, image) in
            DispatchQueue.main.async {
                self.emojiArtBackgroundImage = (url, image)
                //                print ("background image 5.dropInteraction performDrop")
            }
        }
        session.loadObjects(ofClass: NSURL.self) { nsurls in
            if let url = nsurls.first as? URL {
                self.imageFetcher.fetch(url)
                //                print("background image 3.load url load objects")
            }

        }
        session.loadObjects(ofClass: UIImage.self) { images in
            if let image = images.first as? UIImage {
                self.imageFetcher.backup = image
                //                print ("background image 4.loadObjects images ")
            }

        }


        func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
            //        print("emoji 3.canHandle dragsession in collectionview")
            return session.canLoadObjects(ofClass: NSAttributedString.self)

        }

        func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
            if let indexPath = destinationIndexPath, indexPath.section == 1 {
                let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
                return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
            } else {
                return UICollectionViewDropProposal(operation: .cancel)
            }
        }

        func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
            let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item:0, section: 0)
            for item in coordinator.items {
                if let sourceIndexPath = item.sourceIndexPath {
                    if let attributedString = item.dragItem.localObject as?
                        NSAttributedString {
                        //so that updates can be performed w/out having to sync with model each operation
                        collectionView.performBatchUpdates({
                            emojis.remove(at: sourceIndexPath.item)
                            emojis.insert(attributedString.string, at: destinationIndexPath.item)
                            collectionView.deleteItems(at: [sourceIndexPath])
                            collectionView.insertItems(at: [destinationIndexPath])
                        })
                        print ("emoji 4a.perform drop in collection view")
                        coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                    }
                }else {
                    //swap out placeholder cell for actual cell
                    let placeholderContext = coordinator.drop(
                        item.dragItem,
                        to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "DropPlaceholderCell")
                    )
                    item.dragItem.itemProvider.loadObject(ofClass: NSAttributedString.self) {
                        (provider, error) in
                        DispatchQueue.main.async {
                            if let attributedString = provider as? NSAttributedString {
                                placeholderContext.commitInsertion(dataSourceUpdates: {insertionIndexPath in
                                    self.emojis.insert(attributedString.string, at: insertionIndexPath.item)
                                })
                                print ("add emoji to collection view from non local source")
                            } else {
                                placeholderContext.deletePlaceholder()
                            }
                        }
                    }
                }
            }
        }

    }

}
