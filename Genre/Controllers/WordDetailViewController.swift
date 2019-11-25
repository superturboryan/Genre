//
//  WordDetailViewController.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-11-03.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit

class WordDetailViewController: UIViewController, LanguageChange {

    @IBOutlet var titleLabel: UILabel!
    
    var word: Word = Word()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) { overrideUserInterfaceStyle = .light }
        
        self.titleLabel.text = self.word.word
        
        self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func updateLanguageLabels() {
        
        guard let currentLanguageIsFrench = options.value(forKey: "FrenchLanguage") as? Bool
            else {fatalError()}
        
        if (currentLanguageIsFrench == true) {
            
        }
        else {
            
        }
    }
    
    
    

}
