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
    @IBOutlet weak var gameFinishedTextLabel: UILabel!
    
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
        self.titleLabel.text = ouiEnFrancais ? "Résultats" : "Results"
    }
    
    func setupGameFinishedLabel(forScore score:Float) {
        
        var displayText = ""
        
        switch(score) {
            case ..<0.1:
                displayText = ouiEnFrancais ? "Essayez l'autre réponse!" : "Try the other answer!"
                break
            case 0.1..<0.4:
                displayText = ouiEnFrancais ? "Faudrait étudier un peu!" : "Study the word list!"
                break
            case 0.4..<0.6:
                displayText = ouiEnFrancais ? "Presque mieux que deviner" : "Almost better than guessing!"
                break
            case 0.6..<0.8:
                displayText = ouiEnFrancais ? "Continuez c'est bien!" : "Getting there, keep going!"
                break
            case 0.8..<0.9:
                displayText = ouiEnFrancais ? "Allez presque rendu!" : "Keep it up, almost there!"
                break
            case 0.9...:
                displayText = ouiEnFrancais ? "Bravo, excellent travail!" : "Bravo! Job well done!"
                break
            default:
                displayText = "Bravo! Well done!"
        }
        
        self.gameFinishedTextLabel.text = displayText
    }
}
