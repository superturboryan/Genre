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
            
            saveChangesToCoreData()
            
//            if let hint: String = WordChecker.checkLastTwoLettersForHint(word: wordString) {
//                wordToAdd.setHint(hint: hint)
//            }
        }
    }
    
    func saveChangesToCoreData() {
        
        do{
           try self.delegateContext.save()
            print("Changes saved to Core Data")
        }
        catch {
            print("Error updating Core Data")
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
    
    func getWordFor(string: String) -> Word? {
        
        let request : NSFetchRequest<Word> = Word.fetchRequest()
//        let entity = NSEntityDescription.entity(forEntityName: "Word", in: delegateContext)
        
        request.predicate = NSPredicate(format:"word = %@", string)
        request.fetchLimit = 1
        
        do{
            let fetchResult = try delegateContext.fetch(request)[0]

            if (fetchResult.word != "") { return fetchResult }
        }
        catch {
            print("Error loading word from Core Data")
        }
        
        return nil
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
