//
//  CSVLoader.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-10-04.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit
import CSV
import CoreData


class WordBank: NSObject {
    
    
    static let sharedInstance = WordBank()
    
    let delegateContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func checkIfCSVHasBeenLoaded() -> Bool {
        
        let request : NSFetchRequest<Word> = Word.fetchRequest()
        
        do{
            let fetchResult = try delegateContext.fetch(request)

            if (fetchResult.count != 0) { return true }
        }
        catch {
            print("Error checking if CSV was loaded into Core Data")
        }
        
        return false
    }
    
    
    func loadCsvIntoCoreData(){
        
        let stream = InputStream(fileAtPath: Bundle.main.path(forResource: "Words1592WithAccents", ofType: "csv")!)
        
        let csv = try! CSVReader(stream: stream!)
        
        var wordList = [String:String]()
        
        while let row = csv.next() {
            wordList[row[0]] = row[1]
        }
        
        wordList.forEach { (wordTuple) in
            
            var (wordString, genderString) = wordTuple
            
            wordString = wordString.trimmingCharacters(in: .whitespacesAndNewlines)
            genderString = genderString.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let genderBool = genderString == "True" ? true : false
            
            let wordToInsert = Word(context: self.delegateContext)
            
            wordToInsert.word = wordString
            wordToInsert.gender = genderBool
            wordToInsert.correctCount = 0
            wordToInsert.incorrectCount = 0
            wordToInsert.hint = "No hint"
            
            do{
               try self.delegateContext.save()
                print("Added word \(wordString) into Core Data")
            }
            catch {
                print("Error saving word \(wordString) into Core Data")
            }
            
//            if let hint: String = WordChecker.checkLastTwoLettersForHint(word: wordString) {
//                wordToAdd.setHint(hint: hint)
//            }
        }
    }
    
    
    func getAllWordsUnordered() -> [Word] {
        
        let request : NSFetchRequest<Word> = Word.fetchRequest()
        
        do{
            let fetchResult = try delegateContext.fetch(request)

            if (fetchResult.count != 0) { return fetchResult }
        }
        catch {
            print("Error loading word from Core Data")
        }
        return []
    }
    
    
    func getAllWordAlphabetical() -> [Word] {
        
        let request : NSFetchRequest<Word> = Word.fetchRequest()
        
        do{
            let fetchResult = try delegateContext.fetch(request)

            if (fetchResult.count != 0) {
                
                let alphabeticalWordList = fetchResult.sorted(by: { (first, second) -> Bool in
                    if (first.word! < second.word!) { return true }
                    return false
                })
                
                return alphabeticalWordList
            }
        }
        catch {
            print("Error loading word from Core Data")
        }
        return []
    }
    
    
    func getRandomWordsFor(count: Int) -> [Word] {
        
        let request : NSFetchRequest<Word> = Word.fetchRequest()
        request.fetchLimit = count
        
        do{
            let fetchResult = try delegateContext.fetch(request)

            if (fetchResult.count != 0) { return fetchResult }
        }
        catch {
            print("Error loading word from Core Data")
        }
        return []
    }
    
}
