//
//  CSVLoader.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-10-04.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit
import CSV

class WordBank: NSObject {
    
    static let sharedInstance = WordBank()
    
    var wordList = [String:String]()
    var wordArray: [Word] = Array()
    var questionBank: [Word] = Array()
    
    func loadCSV(){
        
        let stream = InputStream(fileAtPath: Bundle.main.path(forResource: "Words1592WithAccents", ofType: "csv")!)
        let csv = try! CSVReader(stream: stream!)
        
        while let row = csv.next() {
            wordList[row[0]] = row[1]
        }
        
        wordList.forEach { (wordTuple) in
            var (wordString, genderString) = wordTuple
            
            wordString = wordString.trimmingCharacters(in: .whitespacesAndNewlines)
            genderString = genderString.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let genderBool = genderString == "True" ? true : false
            
            let wordToAdd = Word(word: wordString, gender: genderBool)
            
            if let hint: String = WordChecker.checkLastTwoLettersForHint(word: wordString) {
                wordToAdd.setHint(hint: hint)
            }
            
            wordArray.append(wordToAdd)
        }
    }
    
    func loadQuestionBank(numOfQuestions : Int) {
        
        questionBank = []
        
        var x = 0
        
        while x < numOfQuestions {
            
            questionBank.append(wordArray.randomElement()!)
            x += 1
        }
    }

}
