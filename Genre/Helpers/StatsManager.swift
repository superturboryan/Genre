//
//  StatsManager.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-11-17.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit

class StatsManager: NSObject {

    static let sharedInstance = StatsManager()
    
    func getOverallCorrectPercentage() -> Double {
        if (options.integer(forKey: kCorrectCount) == 0) { return 0 }
        return (Double(options.integer(forKey: kCorrectCount)) / (Double(options.integer(forKey: kCorrectCount)) + Double(options.integer(forKey: kIncorrectCount)))) * 100
    }
    
    func getOverallCorrectPercentage(forGender gender:Bool) -> Double {
        let key = gender ? kMascCorrectCount : kFemCorrectCount
        if options.integer(forKey: key) == 0 { return 0 }

        return gender == true ?
        (Double(options.integer(forKey: kMascCorrectCount)) / (Double(options.integer(forKey: kMascCorrectCount)) + Double(options.integer(forKey: kMascIncorrectCount)))) * 100
        :
        (Double(options.integer(forKey: kFemCorrectCount)) / (Double(options.integer(forKey: kFemCorrectCount)) + Double(options.integer(forKey: kFemIncorrectCount)))) * 100
    }
    
    func getTotalSessionsCount() -> Int {
        return SessionManager.sharedInstance.getAllSessions().count
    }
    
    func getTotalAnswerCount() -> Int {
        return getAnswerCount(forGender: true) + getAnswerCount(forGender: false)
    }
    
    func getAnswerCount(forGender gender:Bool) -> Int {
        return gender == true ? (getCorrectCount(forGender: true) + getIncorrectCount(forGender: true)) :
                                (getCorrectCount(forGender: false) + getIncorrectCount(forGender: false))
    }
    
    func getCorrectCount(forGender gender:Bool) -> Int {
        return gender == true ? options.integer(forKey: kMascCorrectCount) : options.integer(forKey: kFemCorrectCount)
    }

    func getIncorrectCount(forGender gender:Bool) -> Int  {
        return gender == true ? options.integer(forKey: kMascIncorrectCount) : options.integer(forKey: kFemIncorrectCount)
    }
    

}
