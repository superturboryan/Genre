//
//  SessionManager.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-10-20.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit
import CoreData

class SessionManager: NSObject {

    static let sharedInstance = SessionManager()
    
    let delegateContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func registerNewSessionWith(withScore score: Int32, outOf total: Int32) {
        
        let newSession = Session(context: delegateContext)
        
        newSession.correctCount = score
        
        newSession.incorrectCount = total - score
        
        newSession.timeStamp = Date()
        
        saveChangesToCoreData()
    }
    
    //MARK: Save changes to Core Data
       
    func saveChangesToCoreData() {
       
       do{
          try self.delegateContext.save()
           print("Session saved to Core Data")
       }
       catch {
           print("Error saving sesion to Core Data")
       }
    }
    
    //MARK: Get all sessions
    
    func getAllSessions() -> [Session] {
        
        let request : NSFetchRequest<Session> = Session.fetchRequest()
        
        do{
            let fetchResult = try delegateContext.fetch(request)

            if (fetchResult.count != 0) { return fetchResult }
        }
        catch {
            print("Error loading sessions from Core Data")
        }
        return []
        
    }
    
    func getLastFiveSessions() -> [Session] {
        
        let allSessions = getAllSessions()
        
        let lastFiveSessions = allSessions.suffix(5)
        return Array(lastFiveSessions)
    }
}
