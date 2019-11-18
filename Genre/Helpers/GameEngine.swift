//
//  GameEngine.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-10-08.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import Foundation
import CoreData

struct Answer {
    var gender: Bool
    var correct: Bool
}

class GameEngine: NSObject {
    
    //MARK:- Properties
    
    static let sharedInstance = GameEngine()
    
    let AppOptions = UserDefaults.standard
    
    var currentQuestionIndex : Int = 0
    var numberOfQuestionsForGame : Int = 10
    var userScore : Int = 0
    var timeLimitPerWord:Int = 0
    
    var masculineCorrect : Int = 0
    var masculineIncorrect : Int = 0
    var feminineCorrect: Int = 0
    var feminineIncorrect: Int = 0
    
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
            loadSettings()
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
    
    func addAnswerToEngine(_ answer:Answer) {
        answer.gender ? (answer.correct ? (self.masculineCorrect+=1) : (self.masculineIncorrect+=1)) : (answer.correct ? (self.feminineCorrect+=1) : (self.feminineIncorrect+=1))
    }
    
    func saveGameAndUpdateStats() {
        
        let incorrectCount: Int = (numberOfQuestionsForGame - userScore)
        let newTotalIncorrectCount: Int = options.integer(forKey: kIncorrectCount) + incorrectCount
        let newTotalCorrectCount: Int = options.integer(forKey: kCorrectCount) + GameEngine.sharedInstance.userScore
        
        let newIncorrectMasculineCount: Int = options.integer(forKey: kMascIncorrectCount) + masculineIncorrect
        let newCorrectMasculineCount: Int = options.integer(forKey: kMascCorrectCount) + masculineCorrect
        let newIncorrectFeminineCount: Int = options.integer(forKey: kFemIncorrectCount) + feminineIncorrect
        let newCorrectFeminineCount: Int = options.integer(forKey: kFemCorrectCount) + feminineCorrect
        
        options.set(newTotalIncorrectCount, forKey: kIncorrectCount)
        options.set(newTotalCorrectCount, forKey: kCorrectCount)
        options.set(newIncorrectMasculineCount, forKey: kMascIncorrectCount)
        options.set(newCorrectMasculineCount, forKey: kMascCorrectCount)
        options.set(newIncorrectFeminineCount, forKey: kFemIncorrectCount)
        options.set(newCorrectFeminineCount, forKey: kFemCorrectCount)
        
        SessionManager.sharedInstance.registerNewSessionWith(withScore: Int32(userScore), outOf: Int32(numberOfQuestionsForGame))
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
    func checkAnswer(pickedAnswer: Bool) -> Bool {
        
        let currentWord = gameWords[currentQuestionIndex]
        let correctAnswer = currentWord.gender
        let correctResult = pickedAnswer == correctAnswer
        let answer = Answer(gender: pickedAnswer, correct: correctResult)
        
        addAnswerToEngine(answer)
        
        if correctResult {
            incrementUserScore()
            incrementCountFor(word: currentWord, correct: true)
            return true
        }
        else{
            incrementCountFor(word: currentWord, correct: false)
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
