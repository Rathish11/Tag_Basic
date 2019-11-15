//
//  TagCollectionViewCell.swift
//  Tag_Basic
//
//  Created by Rathish Marthandan T on 13/11/19.
//  Copyright © 2019 Rathish Marthandan T. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var baseView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        DispatchQueue.main.async {
            [self.baseView, self.imageView].forEach { (view) in
                view?.layer.cornerRadius = (view?.frame.height ?? 0)/2
                view?.clipsToBounds = true
                view?.layoutIfNeeded()
            }
            
            self.baseView.backgroundColor = UIColor.orange.withAlphaComponent(0.6)
            self.imageView.image = UIImage.init(imageLiteralResourceName: "user.png")
            self.layoutIfNeeded()
        }
    }
    
    func populate(_ tag: Tag) -> Void {
        self.nameLabel.text = tag.name
        self.layoutIfNeeded()
    }

}
