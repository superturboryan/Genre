//
//  GameViewController.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-03-13.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit
import CSV
import ProgressHUD
import ChameleonFramework

class GameViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var plusOneLabel: UILabel!
    
    @IBOutlet weak var restartButton: UIButton!
    
    
    //MARK: - Variables
    
    //Game variables
    
    private var startTime = Date()
    
    private var wordList : [String] = []
    
    internal var wordArray : [Word] = []
    
    private var pickedAnswer : String = "True"
   
    private var questionNumber : Int = 0
    
    private var userScore : Int = 0
    
    private var questionBank : [Word] = []
    
    internal var numberOfQuestions : Int = 10
    
    //UI Variables
    
    var wordCardView : WordCardView!
    
    var gameFinishedView : GameFinishedView!
    
    enum SwipeDirection {
        case left, right
    }
    
    lazy var panRecognizer : UIPanGestureRecognizer = {
        
        let recognizer = UIPanGestureRecognizer()
        
        recognizer.addTarget(self, action : #selector(wordCardViewPanned(recognizer:)))
        
        return recognizer
    }()
    
    var animator : UIViewPropertyAnimator = UIViewPropertyAnimator()
    
    var animateProgress : CGFloat = 0
    
    var currentSwipeDirection : SwipeDirection!
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: - View load, appear, disappear
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up restart button for later
        restartButton.layer.shadowColor = UIColor.black.cgColor
        restartButton.layer.shadowOpacity = 0.4
        restartButton.layer.shadowOffset = CGSize.zero
        restartButton.layer.shadowRadius = CGFloat(12)
        
        restartButton.layer.cornerRadius = CGFloat(10)
        
        restartButton.alpha = 0
        
        loadCSV()
        
        loadQuestionBank(numOfQuestions : numberOfQuestions)
        
        plusOneLabel.alpha = 0
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        createNewCard()
        
        updateUI(questionNum : questionNumber)
    }
    
    func updateUI(questionNum : Int) {
        
        wordCardView.wordLabel.text = questionBank[questionNumber].word
        scoreLabel.text = "\(userScore) / \(numberOfQuestions)"

    }
    
    
    @objc func wordCardViewPanned(recognizer : UIPanGestureRecognizer) {
        
        switch recognizer.state {
            
        ////////////
        case .began:
            
            let translation = recognizer.translation(in: wordCardView)
            
            if translation.x > 0 {
                //animation moving to right
                animateSwipe(direction: .right)
                
            }
            else {
                //animate moving to left
                animateSwipe(direction: .left)
                
            }
            //when animation stops, pause it to make scrubbable
            animator.pauseAnimation()
            
            animateProgress = animator.fractionComplete
            
        //////////////
        case .changed:
            
            let translation = recognizer.translation(in: wordCardView)
            
            var fraction = translation.x / (view.frame.width)
            
            if currentSwipeDirection == .left {
                
                fraction *= -1
            }
            
            animator.fractionComplete = fraction + animateProgress
            
            if animator.fractionComplete == CGFloat(0) {
                
                if currentSwipeDirection == .left && translation.x > 0 {
                    
                    refreshAnimator(direction: .right)
                }
                else if currentSwipeDirection == .right && translation.x < 0 {
                    
                    refreshAnimator(direction: .left)
                }
            }
            
        ////////////
        case .ended:
            
            let velocity = recognizer.velocity(in: wordCardView)
            
            //If more than 0.4 is complete, do completion block and remove
            
            if velocity.x > 60 || velocity.x < -60 || animator.fractionComplete > 0.4 {
                
                animator.addCompletion { (position) in
                    
                    if velocity.x > 0 {
                        self.pickedAnswer = "True"
                    }
                    else if velocity.x < 0 {
                        self.pickedAnswer = "False"
                    }
                    
                    //Check answer here after setting pickedAnswer
                    self.checkAnswer()
                    
                    //Remove answered card from view
                    self.wordCardView.removeFromSuperview()
                    
                    self.questionNumber += 1
                   
                    //Check if quiz has finished!
                    if self.questionNumber == self.questionBank.count {
                        self.gameFinishedPopup()
                    }
                    else{
                        //Add new card to view
                        self.createNewCard()
                        self.updateUI(questionNum: self.questionNumber)
                    }
                                    }
                
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                break
                
            }
            
            animator.isReversed = true
            
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            
            
        ////////
        default:
            ()
    
        }
    }
    
    func checkAnswer() {
        
        let correctAnswer = questionBank[questionNumber].gender
        
        if pickedAnswer == correctAnswer {
            
            userScore += 1
            print("Correct!")
            
            UIView.animate(withDuration: 0.4, animations: {
                
                self.plusOneLabel.alpha = 1
                
            }) { (success) in
            
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.plusOneLabel.alpha = 0
                    
                }, completion: nil)
            }
            
        }
        else{
            print("Incorrect!")
        }
        
    }
    
    
    
    func animateSwipe(direction : SwipeDirection) {
        
        if animator.isRunning { return }
        
        currentSwipeDirection = direction
        
        animator = UIViewPropertyAnimator(duration: 0.6, curve: .easeIn, animations: {
            
            //Move left or right along x axis
            let transform = CGAffineTransform(translationX: direction == .right ? self.view.frame.width : -self.view.frame.width , y: 0) // Right Direction : Left Direction
            
            //Combine previous transform with rotation
            self.wordCardView.transform = CGAffineTransform(rotationAngle: direction == .right ? CGFloat(Double.pi / 8) : -CGFloat(Double.pi / 8)).concatenating(transform)
            
        })
        
        animator.startAnimation()
    }
    
    
    func refreshAnimator(direction : SwipeDirection) {
        
        currentSwipeDirection = direction
        
        animator.stopAnimation(true)
        
        animator = UIViewPropertyAnimator(duration: 0.8, curve: .easeIn, animations: {
            
            //Move left or right along x axis
            let transform = CGAffineTransform(translationX: direction == .right ? self.view.frame.width : -self.view.frame.width , y: 0) // Right Direction : Left Direction
            
            //Combine previous transform with rotation
            self.wordCardView.transform = CGAffineTransform(rotationAngle: direction == .right ? CGFloat(Double.pi / 8) : -CGFloat(Double.pi / 8)).concatenating(transform)
            
        })
        
        animator.startAnimation()
        
        animator.pauseAnimation()
        
        animateProgress = animator.fractionComplete
        
    }
    
    
    
    func createNewCard() {
        
        wordCardView = UINib(nibName: "WordCardView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? WordCardView
        
        wordCardView.frame = CGRect(x: 30, y: (view.frame.height - CGFloat(290)) / 2 , width: view.frame.width - CGFloat(60), height: 290)
        
        view.addSubview(wordCardView)
        
        wordCardView.addGestureRecognizer(panRecognizer)
        
        wordCardView.isUserInteractionEnabled = true
        
        //Hide and shrink card before showing with animation
        wordCardView.alpha = 0
        wordCardView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
      
        
        UIView.animate(withDuration: 0.3) {
            
            //Reverse fading and shrinking
            self.wordCardView.alpha = 1
            
            self.wordCardView.transform = CGAffineTransform.identity
        
        }
    }
    
    func gameFinishedPopup() {
        
        
        gameFinishedView = UINib(nibName: "GameFinishedView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? GameFinishedView
        
        gameFinishedView.frame = CGRect(x: 30, y: (view.frame.height - CGFloat(290)) / 2 , width: view.frame.width - CGFloat(60), height: 290)
        
        view.addSubview(gameFinishedView)
        
        let endTime = Date()
        
        let timeElapsed  =  String(format: "%.1f", endTime.timeIntervalSince(startTime))
        
        let percentage = String(format: "%.1f" , (Double(userScore) / Double(questionBank.count)) * 100.0)
        
        gameFinishedView.correctAnswers.text = "Réponses correctes: \(userScore) / \(questionBank.count)"
        gameFinishedView.percentage.text = "Pourcentage: " + percentage + "%"
        gameFinishedView.chrono.text = "Chrono: " + timeElapsed + "s"
        
        
        gameFinishedView.alpha = 0
        gameFinishedView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        UIView.animate(withDuration: 0.4) {
            
            self.gameFinishedView.alpha = 1
            self.gameFinishedView.transform = CGAffineTransform.identity
            self.scoreLabel.alpha = 0
            self.view.backgroundColor = self.view.backgroundColor?.darken(byPercentage: 0.7)
            self.restartButton.alpha = 1
            
        }
        
    }
    
    @IBAction func restartPressed(_ sender: UIButton) {
        
        userScore = 0
        questionNumber = 0
        loadQuestionBank(numOfQuestions: numberOfQuestions)
        startTime = Date()
        
        UIView.animate(withDuration: 0.4) {
            self.restartButton.alpha = 0
            self.scoreLabel.alpha = 1
            self.view.backgroundColor = self.view.backgroundColor?.lighten(byPercentage: 0.7)
            self.gameFinishedView.removeFromSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.createNewCard()
            self.updateUI(questionNum: self.questionNumber)
        }
        
        
    }
    
    
}

extension GameViewController {
    
    func loadCSV(){
        let stream = InputStream(fileAtPath: Bundle.main.path(forResource: "Words1592Count", ofType: "csv")!)
        let csv = try! CSVReader(stream: stream!)
        
        while let row = csv.next() {
            let csvInput = row.joined(separator: " ")
            wordList.append(csvInput)
        }
        
        let listString = wordList.joined()
        let indStrings : [String]
        indStrings = listString.components(separatedBy: " ")
        
        var x = 0
        while x < indStrings.count-1 {
            let addWord = Word(word: indStrings[x], gender: indStrings[x+1])
            x = x+2
            wordArray.append(addWord)
        }
    }
    
    func loadQuestionBank(numOfQuestions : Int) {
        
        questionBank = []
        
        var x = 0
        
        while x < numberOfQuestions {
            
            questionBank.append(wordArray.randomElement()!)
            x += 1
        }
    }
    
}

