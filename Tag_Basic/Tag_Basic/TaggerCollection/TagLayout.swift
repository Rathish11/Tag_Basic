//
//  TagLayout.swift
//  Tag_Basic
//
//  Created by Rathish Marthandan T on 13/11/19.
//  Copyright © 2019 Rathish Marthandan T. All rights reserved.
//

import UIKit

protocol TagLayoutDelegate : class {
    func getSizeOfItem(atIndexPath indexPath: IndexPath) -> CGSize
}

class TagLayout: UICollectionViewFlowLayout {
    
    weak var delegate: TagLayoutDelegate? = nil

    private var cache = [UICollectionViewLayoutAttributes]()

    private var contentHeight: CGFloat = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView?.contentInset
        return (collectionView?.bounds.width ?? 0) - ((insets?.left ?? 0) + (insets?.right ?? 0))
    }

    override public var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        super.prepare()
        
        cache.removeAll()
        contentHeight = 0
        
        var xOffSet: CGFloat = self.sectionInset.left
        var yOffSet: CGFloat = self.sectionInset.top
        
        let interLineSpacing: CGFloat = self.minimumLineSpacing
        let collectionViewBounds = self.collectionView?.bounds ?? CGRect.zero
        
        let numberOfItems = self.collectionView?.numberOfItems(inSection: 0) ?? 0
        
        for item in 0 ..< numberOfItems {
            
            let indexPath = IndexPath(item: item, section: 0)

            var tagSize = self.delegate?.getSizeOfItem(atIndexPath: indexPath) ?? CGSize.zero
            
            if (xOffSet + tagSize.width) >= self.getTotalAvailableSpace(collectionViewBounds) {
                
                if tagSize.width >= self.getTotalAvailableSpace(collectionViewBounds) {
                    tagSize.width = self.getTotalAvailableSpace(collectionViewBounds)
                }
                xOffSet = self.sectionInset.left
                yOffSet += tagSize.height  + interLineSpacing
            }
            
            let frame = CGRect.init(x: xOffSet, y: yOffSet, width: tagSize.width, height: tagSize.height)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            attributes.frame = frame
            
            self.cache.append(attributes)
            
            self.contentHeight = max(self.contentHeight, frame.maxY)
            
            xOffSet += tagSize.width + interLineSpacing
            
        }

    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        super.layoutAttributesForElements(in: rect)

        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        cache.forEach { (attribute) in  attribute.frame.intersects(rect) ? layoutAttributes.append(attribute) : nil  }
        return layoutAttributes
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        attribute?.alpha = 0.0
        attribute?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        return attribute
    }

    func getTotalAvailableSpace(_ rect:CGRect) -> CGFloat {
        return (rect.width - (self.sectionInset.left + self.sectionInset.right))
    }

}
