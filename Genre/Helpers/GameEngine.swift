//
//  GameEngine.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-10-08.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import Foundation

class GameEngine: NSObject {
    
    static let sharedInstance = WordBank()
    
    var numberOfQuestions : Int = 10
    var currentQuestionNumber : Int = 1
    var userScore : Int = 0
    
    var gameWords: [Word] = Array()
    
    func loadGameWords(numOfQuestions : Int) {
        
        gameWords = []
        
        for _ in (0...numberOfQuestions) {
            gameWords.append(WordBank.sharedInstance.wordArray.randomElement()!)
        }
    }
    
}
