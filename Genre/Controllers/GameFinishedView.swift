//
//  GameFinishedView.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-03-13.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit

class GameFinishedView: UIView, LanguageChange {

    //MARK:Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var correctAnswers: UILabel!
    @IBOutlet weak var percentage: UILabel!
    @IBOutlet weak var chrono: UILabel!
    @IBOutlet weak var wpm: UILabel!
    
    //MARK:Lifecycle
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        self.addShadow()
        
        self.updateLanguageLabels()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = CGFloat(20)
    }
    
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = CGFloat(12)
    }
    
    func updateLanguageLabels() {
        self.titleLabel.text = ouiEnFrancais ? "Vos résultats" : "Your results"
    }
}
