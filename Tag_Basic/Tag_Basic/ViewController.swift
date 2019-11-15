//
//  ViewController.swift
//  Tag_Basic
//
//  Created by Rathish Marthandan T on 13/11/19.
//  Copyright © 2019 Rathish Marthandan T. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var tagView: TaggerCollectionView = {
        let tagView: TaggerCollectionView = TaggerCollectionView.loadFromXib()
        return tagView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadTagger()
    }

    func loadTagger() {
        
        self.view.addSubview(tagView)
        tagView.g_pin(width: UIScreen.main.bounds.width)
        tagView.g_pin(height: UIScreen.main.bounds.height)
        tagView.g_pinCenter()

    }
    
    @IBAction func add() {
        self.tagView.add()
    }


}

