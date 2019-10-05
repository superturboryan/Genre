//
//  WordChecker.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-10-01.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import Foundation

class WordChecker {
    
    static func checkLastTwoLettersForHint(word:String) -> (String?) {

        if let lastTwoLetters = self.getLastTwoLetters(word: word) {
            
            let masculineHints = ["oi","nt","et","er","er","me","it"]
            
            let feminineHints = ["ée","té","ie","re","le","te","re","ce"]
            
            if masculineHints.contains(lastTwoLetters) {return (lastTwoLetters + " -> probably masculine!")}
            
            if feminineHints.contains(lastTwoLetters) {return (lastTwoLetters + " -> probably feminine!")}
            
            return "No hints!"
        }
        
        return "Too $hort"
    }

    static func getLastTwoLetters(word:String) -> (String?) {
        
        if word.count < 3 {
            return nil
        }
        let index = word.index(word.endIndex, offsetBy: -2)
        var lastTwoLetters = String(word.suffix(from: index))
        return lastTwoLetters
    }
        
}
