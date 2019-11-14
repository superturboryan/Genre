//
//  GameEngine.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-10-08.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import Foundation
import CoreData

class GameEngine: NSObject {
    
    //MARK:- Properties
    
    static let sharedInstance = GameEngine()
    
    let AppOptions = UserDefaults.standard
    
    var numberOfQuestionsForGame : Int = 10
    
    var currentQuestionIndex : Int = 0
    
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
    }
    
    func restartGame(withNewWords toggle:Bool) {
        
        if toggle {
            loadNewGameWords()
        }
        
        resetCurrentQuestionNumber()
        resetCurrentQuestionNumber()
        resetUserScore()
    }
    
    //MARK:- Loading

    func loadSettings() {
        numberOfQuestionsForGame = AppOptions.integer(forKey: "WordCount")
        showHints = AppOptions.bool(forKey: "Hints")
        showTimer = AppOptions.bool(forKey: "Timer")
        showProgressBar = AppOptions.bool(forKey: "Progress")
    }

    func loadNewGameWords() {
        gameWords = WordManager.sharedInstance.getRandomWordsFor(count: numberOfQuestionsForGame)
    }
    
    //MARK:- Game State
    func isGameFinished() -> Bool {
        if currentQuestionIndex == numberOfQuestionsForGame { return true };
        return false;
    }

    func goToNextQuestion() {
        currentQuestionIndex += 1
    }

    func resetCurrentQuestionNumber() {
        currentQuestionIndex = 0
    }

    func incrementUserScore() {
        userScore += 1
    }
    
    func resetUserScore() {
        userScore = 0
    }
    
    //MARK:- Current word properties
    
    func getCurredWord() -> Word {
        return gameWords[currentQuestionIndex]
    }
    
    func getCurrentWordString() -> String {
        return gameWords[currentQuestionIndex].word!
    }
    
    func getCurrentWordGender() -> Bool {
        return gameWords[currentQuestionIndex].gender
    }
    
    func getCurrentWordHint() -> String? {
        return gameWords[currentQuestionIndex].hint
    }
    
    //MARK:- Check Answer
    func checkAnswer(pickedAnswer: Bool?) -> Bool {
        
        let currentWord = gameWords[currentQuestionIndex]
        
        let correctAnswer = currentWord.gender
        
        if pickedAnswer == correctAnswer {
            
            incrementUserScore()
            
            incrementCountFor(word: currentWord, correct: true)
            
            print("Correct!")
            return true
        }
        else{
            
            incrementCountFor(word: currentWord, correct: false)
            
            print("Incorrect!")
            return false
        }
    }
    
    func incrementCountFor(word: Word, correct: Bool) {
        
        let wordToIncrement = WordManager.sharedInstance.getWordFor(string: word.word!)!
        
        if (correct) {
            wordToIncrement.correctCount += 1
        }
        else {
            wordToIncrement.incorrectCount += 1
        }
        
        WordManager.sharedInstance.saveChangesToCoreData()
        
    }
}
