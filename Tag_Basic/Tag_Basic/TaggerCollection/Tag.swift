//
//  Tag.swift
//  Tag_Basic
//
//  Created by Rathish Marthandan T on 13/11/19.
//  Copyright © 2019 Rathish Marthandan T. All rights reserved.
//

import UIKit

class Tag: NSObject {

    private(set) var name: String?  = nil
    private(set) var email: String? = nil

    init(name: String?, email: String? = nil) {
        super.init()
        self.name = name
        self.email = email
    }
    
}
