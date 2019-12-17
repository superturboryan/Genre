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
    
    //Timer variables
    var counter = 0.0
    var timer = Timer()
    
    var timeAttackCounter = 0.0
    var timeAttackTimer = Timer()
    
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
    
    var gameViewDelegate: GameViewDelegate?
    
    //MARK:- Init and lifecycle
    
    override init() {
        super.init()
        
        loadSettings()
    }
    
    func restartGame(withNewWords toggle:Bool) {
        
        if toggle {
            loadNewGameWords()
        }
        
        loadSettings()
        resetCurrentQuestionNumber()
        resetUserScore()
        
        startTimer()
        
        if options.bool(forKey: kTimeAttack) {
            startTimeAttackTimer()
        }
        
    }
    
    func finishGame() {
        
        self.timer.invalidate()
        self.timeAttackTimer.invalidate()
        
    }
    
    func startTimer() {
        self.counter = 0
        self.timer = Timer()
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        counter += 1
        if self.gameViewDelegate?.timerLabel != nil {
            self.gameViewDelegate?.timerLabel.text = String(format:"%.0f",counter)
        }
    }
    
    
    
    func startTimeAttackTimer() {
        self.timeAttackCounter = 3.0
        self.timeAttackTimer = Timer()
        self.timeAttackTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimeAttackTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimeAttackTimer() {
        
        timeAttackCounter -= 1
        
        if timeAttackCounter == 0 {
            self.timeAttackTimer.invalidate()
            self.startTimeAttackTimer()
            self.gameViewDelegate?.timeAttackExpired()
        }
    }
    
    func stopTimeAttackTimer(AndReset reset:Bool) {
        
        timeAttackTimer.invalidate()
        
        if reset {
            startTimeAttackTimer()
        }
    }
    
    //MARK:- Loading

    func loadSettings() {
        numberOfQuestionsForGame = AppOptions.integer(forKey: kWordCount)
        showHints = AppOptions.bool(forKey: kHints)
        showTimer = AppOptions.bool(forKey: kTimer)
        showProgressBar = AppOptions.bool(forKey: kProgress)
    }

    func loadNewGameWords() {
        gameWords = WordManager.sharedInstance.getRandomWordsFor(count: numberOfQuestionsForGame)
    }
    
    //MARK:- Game State
    func isGameFinished() -> Bool {
        currentQuestionIndex += 1
        if currentQuestionIndex == numberOfQuestionsForGame { return true };
        return false;
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
    
    func getCurrentWord() -> Word {
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
            if (options.bool(forKey: kHaptics)) {
                if #available(iOS 13.0, *) { Haptics.impact(forStyle: .soft) }
                else { Haptics.impact(forStyle: .light) }
            }
            
            return true
        }
        else{
            incrementCountFor(word: currentWord, correct: false)
            if options.bool(forKey: kHaptics) {
                options.bool(forKey: kSuddenDeath) ? Haptics.impact(forStyle: .heavy) :  Haptics.notification(forType: .warning)
            }
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
