//
//  GameEngine.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-10-08.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import Foundation

class GameEngine: NSObject {
    
    //MARK:- Properties
    
    static let sharedInstance = GameEngine()
    
    let AppOptions = UserDefaults.standard
    
    var numberOfQuestionsForGame : Int = 10
    
    var currentQuestionNumber : Int = 1
    
    var userScore : Int = 0
    var timeLimitPerWord:Int = 0
    
    var showHints: Bool = false
    var showTimer: Bool = false
    var showProgressBar: Bool = false
    
    var gameWords: [Word] = Array()
    
    //MARK:- Init and lifecycle
    
    override init() {
        super.init()
        
        loadSettings()
        loadNewGameWords()
    }
    
    func restartGame() {
        loadNewGameWords()
        resetCurrentQuestionNumber()
        resetUserScore()
    }
    
    //MARK:- Loading

    func loadSettings() {
        
        showHints = AppOptions.bool(forKey: "Hints")
        showTimer = AppOptions.bool(forKey: "Timer")
        showProgressBar = AppOptions.bool(forKey: "Progress")
    }

    func loadNewGameWords() {
        
        resetCurrentQuestionNumber()
        
        gameWords = []
        
        for _ in (0...numberOfQuestionsForGame) {
            gameWords.append(WordBank.sharedInstance.wordArray.randomElement()!)
        }
    }
    
    //MARK:- Game State
    func isGameFinished() -> Bool {
        if currentQuestionNumber == numberOfQuestionsForGame { return true };
        return false;
    }

    func goToNextQuestion() {
        currentQuestionNumber += 1
    }

    func resetCurrentQuestionNumber() {
        currentQuestionNumber = 0
    }

    func incrementUserScore() {
        userScore += 1
    }
    
    func resetUserScore() {
        userScore = 0
    }
    
    //MARK:- Current word properties
    func getCurrentWordString() -> String {
        return gameWords[currentQuestionNumber].word
    }
    
    func getCurrentWordGender() -> Bool {
        return gameWords[currentQuestionNumber].gender
    }
    
    func getCurrentWordHint() -> String? {
        return gameWords[currentQuestionNumber].hint
    }
    
    //MARK:- Check Answer
    func checkAnswer(pickedAnswer: Bool?) -> Bool {
        
        let correctAnswer = GameEngine.sharedInstance.getCurrentWordGender()
        
        if pickedAnswer == correctAnswer {
            
            GameEngine.sharedInstance.incrementUserScore()
            print("Correct!")
            return true
        }
        else{
            print("Incorrect!")
            return false
        }
    }
}
