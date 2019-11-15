//
//  TaggerCollectionView.swift
//  Tag_Basic
//
//  Created by Rathish Marthandan T on 13/11/19.
//  Copyright © 2019 Rathish Marthandan T. All rights reserved.
//

import UIKit

enum TagViewType {
    case preview, edit
}

class TaggerCollectionView: UIView {
    
    @IBOutlet fileprivate var tagCollectionView: UICollectionView!

    var presentationType: TagViewType        = .edit

    fileprivate let editorCellWidth: CGFloat = 150
    fileprivate let cellHeight: CGFloat      = 30

    fileprivate(set) var tags                = [Tag]()
    
    fileprivate(set) var placeHolder         = "Edit here..."

    fileprivate let TagCellIdentifier        = "TagCollectionViewCell"
    fileprivate let TagEditCellIdentifier    = "TagEditorCollectionViewCell"

    fileprivate let dummyObjects             = ["Hello world", "Make Some Change", "Oh my god", "Hi", "New Sentence", "Awesome"]
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tagCollectionView.register(UINib.init(nibName: TagCellIdentifier, bundle: nil),
                                        forCellWithReuseIdentifier: TagCellIdentifier)
        self.tagCollectionView.register(UINib.init(nibName: TagEditCellIdentifier, bundle: nil),
                                        forCellWithReuseIdentifier: TagEditCellIdentifier)
        
        self.tagCollectionView.delegate = self
        self.tagCollectionView.dataSource = self
        
        let layout = TagLayout()
        layout.delegate = self
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        self.tagCollectionView.collectionViewLayout = layout
        
        generateTags() //ON ACTION
    }
    
    func add(_ tag: String = "") {
        tags.append(Tag.init(name: tag.isEmpty ? getTheRandomName() : tag))
        DispatchQueue.main.async {
            let indexPath = IndexPath.init(row: self.tags.count - 1, section: 0)
            self.tagCollectionView.performBatchUpdates({
                UIView.setAnimationsEnabled(false)
                self.tagCollectionView.insertItems(at: [indexPath])
            }) { (completed) in
                UIView.setAnimationsEnabled(true)
                self.tagCollectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    func delete(atIndexPath indexPath: IndexPath) -> Void {
        self.tags.remove(at: indexPath.item)
        DispatchQueue.main.async {
            self.tagCollectionView.performBatchUpdates({
                let indexPath = IndexPath(row: indexPath.item, section: 0)
                self.tagCollectionView.deleteItems(at: [indexPath])
            }){ (completed) in }
        }
    }
    
}

//MARK:- UICollectionViewDelegate & UICollectionViewDataSource

extension TaggerCollectionView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (presentationType == .preview) ? (tags.count) : (tags.count + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        func getTagCell() -> TagCollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCellIdentifier, for: indexPath) as! TagCollectionViewCell
            cell.populate(tags[indexPath.item])
            return cell
        }
        
        func getTagEditorCell() -> TagEditorCollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagEditCellIdentifier, for: indexPath) as! TagEditorCollectionViewCell
            cell.setPlaceHolder(placeHolder)
            
            cell.didChangeInText = { [weak self] (text) in
                guard self != nil else { return }
                collectionView.collectionViewLayout.invalidateLayout()
            }
            
            cell.doneChangeInText = { [weak self] (text) in
                guard let self = self else { return }
                self.add(text ?? "")
            }
            return cell
        }
        
        if self.presentationType == .preview {
            return getTagCell()
        } else {
            return (indexPath.item < self.tags.count) ? getTagCell() : getTagEditorCell()
        }
        
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard (collectionView.cellForItem(at: indexPath) as? TagCollectionViewCell) != nil else { return }
        self.delete(atIndexPath: indexPath)
    }
                
}

//MARK:- Helper

extension TaggerCollectionView {
    
    private func generateTags() {
        for _ in 0..<10 { tags.append(Tag.init(name: getTheRandomName())) }
        self.tagCollectionView.reloadData()
    }
    
    func getTheRandomName() -> String {
        return dummyObjects[Int.random(in: 0 ..< 5)]
    }

    func getWidth(for content:String = "", using indexPath:IndexPath, using collectionView : UICollectionView) -> CGFloat {
        return content.width(withConstraintedHeight: collectionView.frame.height, font: UIFont.systemFont(ofSize: 17)) + 62
    }
    
    func getEditorWith() -> CGFloat {
        
        if presentationType == .edit {
            
            let section = self.tagCollectionView.numberOfSections - 1
            let index = self.tagCollectionView.numberOfItems(inSection: 0) - 1
            let indexPath = IndexPath.init(row: index, section: section)
            
            guard let cell = self.tagCollectionView.cellForItem(at: indexPath) as? TagEditorCollectionViewCell else { return editorCellWidth  }
            
            let width = getWidth(for: cell.getContent(), using: indexPath, using: self.tagCollectionView)
            return (width > editorCellWidth) ? width : editorCellWidth
                        
        } else {
            return editorCellWidth
        }
    }

}

//MARK:- TagLayoutDelegate

extension TaggerCollectionView : TagLayoutDelegate {
    
    func getSizeOfItem(atIndexPath indexPath: IndexPath) -> CGSize {
        var size: CGSize = CGSize.zero
        size.width = (indexPath.item < self.tags.count) ? getWidth(for: tags[indexPath.item].name ?? "", using: indexPath, using: self.tagCollectionView) : getEditorWith()
        size.height = cellHeight
        return size
    }
        
}

