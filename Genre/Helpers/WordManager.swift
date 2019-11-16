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


class WordManager: NSObject {
    
    
    //MARK: Variables
    
    static let sharedInstance = WordManager()
    
    let delegateContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: Check if CSV been loaded
    
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
    
    //MARK: Load CSV -> Core Data
    
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
            wordToInsert.favourite = false
            
            saveChangesToCoreData()
            
            //MARK: TODO: Check for hints while adding words to Core Data
//            if let hint: String = WordChecker.checkLastTwoLettersForHint(word: wordString) {
//                wordToAdd.setHint(hint: hint)
//            }
        }
        print("CSV loaded into Core Data")
    }
    
    //MARK: Save changes to Core Data
    
    func saveChangesToCoreData() {
        
        do{
           try self.delegateContext.save()
//            print("Changes saved to Core Data")
        }
        catch {
            print("ERROR: failed to save changes Core Data")
        }
    }
    
    //MARK: Get all words
    
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
            print("Error loading words from Core Data")
        }
        return []
    }
    
    func getIncorrectWords() -> [Word] {
        
        let request : NSFetchRequest<Word> = Word.fetchRequest()
        request.predicate = NSPredicate(format:"incorrectCount != 0")
        
        do{
            var fetchResult = try delegateContext.fetch(request)

            if (fetchResult.count != 0) {
                
                fetchResult = fetchResult.sorted(by: { $0.incorrectCount > $1.incorrectCount })
                return fetchResult
            }
        }
        catch {
            print("Error no incorrect words found!")
        }
        
        return []
    }
    
    func getWordsFor(Filter filter:FilterOption) -> [Word] {
        
        let request : NSFetchRequest<Word> = Word.fetchRequest()
        
        switch filter {
            
            case .all: request.sortDescriptors = [NSSortDescriptor(key: "word", ascending: true)]; break;
                    
            case .incorrect: request.predicate = NSPredicate(format:"incorrectCount != 0"); break;
                
            case .favourite: request.predicate = NSPredicate(format: "favourite != 0"); break;

            case .lastGame: return GameEngine.sharedInstance.gameWords
        }
        
        do{
            var fetchResult = try delegateContext.fetch(request)

            if (fetchResult.count != 0) {
                
                if (filter == .incorrect) {
                    fetchResult = fetchResult.sorted(by: { $0.incorrectCount > $1.incorrectCount })
                }


                return fetchResult
            }
        }
        catch {
            print("Error no incorrect words found!")
        }
        
        return []
    }
    
    //MARK: Get single word
    
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
    
    //MARK: Get words for count
    
    func getRandomWordsFor(count: Int) -> [Word] {
                
        let allWords: [Word] = getAllWordAlphabetical()
        
        var randomWords: [Word] = [Word]()
        
        //count-1 to offset zero index!
        for _ in 0...count-1 {
            randomWords.append(allWords.randomElement()!)
        }
        return randomWords
        
    }
    
    func set(word:Word, favourite:Bool) {
        
        let wordToSet = WordManager.sharedInstance.getWordFor(string: word.word!)!
        
        wordToSet.favourite = favourite
        
        WordManager.sharedInstance.saveChangesToCoreData()
    }
    
}
