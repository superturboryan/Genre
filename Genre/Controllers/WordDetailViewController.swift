//
//  WordDetailViewController.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-11-03.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit

class WordDetailViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    
    var word: Word = Word()
    
    convenience init(word: Word) {
        self.init(nibName:nil, bundle:nil)
        self.word = word
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) { overrideUserInterfaceStyle = .light }
        
        self.titleLabel.text = self.word.word
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    
    
    

}
