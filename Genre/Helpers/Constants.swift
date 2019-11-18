//
//  Constants.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-11-17.
//  Copyright © 2019 Ryan F. All rights reserved.
//


import UIKit

typealias CompletionHandler = () -> Void

let options = UserDefaults.standard

let vowels = ["a","e","i","o","u","h"]

let screenWidth = UIScreen.main.bounds.width
let cellSquareSize: CGFloat = screenWidth / 2.5

let statsNibName = "StatsCircleProgressCell"
let statsCellId = "statsCellId"

// MARK: User Default Keys

let kOptionsSet = "OptionsSet"
let kHints = "Hints"
let kTimer = "Timer"
let kProgress = "Progress"
let kSuddenDeath = "SuddenDeath"
let kWordCount = "WordCount"
let kFrenchLanguage = "FrenchLanguage"
let kCorrectCount = "CorrectCount"
let kIncorrectCount = "IncorrectCount"
let kMascCorrectCount = "MascCorrectCount"
let kMascIncorrectCount = "MascIncorrectCount"
let kFemCorrectCount = "FemCorrectCount"
let kFemIncorrectCount = "FemIncorrectCount"
