//
//  TagEditorCollectionViewCell.swift
//  Tag_Basic
//
//  Created by Rathish Marthandan T on 13/11/19.
//  Copyright © 2019 Rathish Marthandan T. All rights reserved.
//

import UIKit

class TagEditorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet fileprivate var editorField: UITextField!

    var didChangeInText: ((_ text : String?) -> ())? = nil
    var doneChangeInText: ((_ text : String?) -> ())? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.editorField.addTarget(self, action: #selector(didChanged(_:)), for: UIControl.Event.editingChanged)
        self.editorField.delegate = self
    }
    
    func setPlaceHolder(_ placeHolder: String?) {
        self.editorField.placeholder = placeHolder
    }
    
    func getContent() -> String {
        return self.editorField.text ?? ""
    }
    
    @objc func didChanged(_ sender : UITextField) {
        self.didChangeInText?(sender.text)
    }

}

extension TagEditorCollectionViewCell : UITextFieldDelegate {
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.doneChangeInText?(textField.text)
        textField.text = nil
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.didChangeInText?(textField.text)
        return true
    }
    
    
}
