//
//  WordCardView.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-03-13.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit

class WordCardView: UIView {

    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var feminineLabel: UILabel!
    @IBOutlet weak var masculineLabel: UILabel!
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        feminineLabel.alpha = 0
        masculineLabel.alpha = 0
        
        wordLabel.textColor = UIColor.black
        hintLabel.textColor = UIColor.black
        feminineLabel.textColor = UIColor.black
        masculineLabel.textColor = UIColor.black
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = CGFloat(12)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = CGFloat(20)
        
    }
    
}
