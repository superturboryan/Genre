//
//  SessionManager.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-10-20.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit

class SessionManager: NSObject {

    static let sharedInstance = SessionManager()
    
    let delegateContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func registerNewSessionWith(words: [Word], andSessionResults results: [Bool]) {
        
        let newSession = Session(context: delegateContext)
        
        for result in results {
            
            if (result) {newSession.correctCount += 1}
            else {newSession.incorrectCount += 1}
        }
        
    }
    
    
}
