//
//  WordDetailViewController.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-11-03.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit

class WordDetailViewController: UIViewController {

    var word: Word = Word()
    
    convenience init(word: Word) {
        self.init(nibName:nil, bundle:nil)
        self.word = word
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) { overrideUserInterfaceStyle = .light }
        
//        let presentingView = self.navigationController?.viewControllers[1] as! WordListViewController
//
//        self.word = presentingView.selectedWord
//        
//        self.navigationItem.title = self.word.word
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func pressedClose(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    

}
