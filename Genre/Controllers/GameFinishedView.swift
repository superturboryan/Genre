//
//  GameFinishedView.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-03-13.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit

class GameFinishedView: UIView {

    @IBOutlet weak var correctAnswers: UILabel!
    @IBOutlet weak var percentage: UILabel!
    @IBOutlet weak var chrono: UILabel!
    @IBOutlet weak var wpm: UILabel!
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
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
