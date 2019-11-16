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
    
    let options = UserDefaults.standard

    //MARK: - Outlets
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet var backButton: UIButton!
    
    @IBOutlet var correctPopup: UIImageView!
    @IBOutlet var incorrectPopup: UIImageView!
    
    //MARK: - Variables
    
    //Timer variables
    private var counter = 0.0
    private var timer = Timer()
 
    
    //UI Variables
    var wordCardView : WordCardView!
    var gameFinishedView : GameFinishedView!
    
    enum SwipeDirection {
        case left, right
    }
    
    //Pan recognizer for word cards
    lazy var panRecognizer : UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action : #selector(wordCardViewPanned(recognizer:)))
        return recognizer
    }()
    
    //Animator used for swiping
    var animator : UIViewPropertyAnimator = UIViewPropertyAnimator()
    var animateProgress : CGFloat = 0
    var currentSwipeDirection : SwipeDirection!
    
//MARK: - View load, appear, disappear
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5,
                       delay: 0.1,
                       options: .curveEaseOut,
                       animations: {
            self.view.backgroundColor = self.view.backgroundColor?.lighten(byPercentage: 0.33)
        }, completion: nil)

        updateUI(withNewCards: 1)
        startTimer()
    }
    
    @objc func setupView() {
        
        self.view.setupGradientBG(withFrame: self.view.bounds)
        
        self.view.bringSubviewToFront(self.backButton)
        
        restartButton.layer.cornerRadius = CGFloat(10)
        restartButton.alpha = 0
        progressBar.frame.size.width = CGFloat(0)
        
        correctPopup.alpha = 0
        incorrectPopup.alpha = 0
        
        correctPopup.layer.cornerRadius = 10
        incorrectPopup.layer.cornerRadius = 10
        
       //Check whether to display timer
        if options.value(forKey: "Timer") as! Bool == false { timerLabel.alpha = 0 }
       //And whether to display progress bar
        if options.value(forKey: "Progress") as! Bool == false { progressBar.alpha = 0 }
    
        timerLabel.text = String(counter)
    
        hideNavBar()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            // Transform similar to card swipe animation
            let transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
            self.wordCardView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 8)).concatenating(transform)
        }) { (completion) in
            // DismissVC sans animation because backgrounds are all the same
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    @objc func hideNavBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc func startTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    
    @objc func updateUI(withNewCards count:Int) {
        
        scoreLabel.text = "\(GameEngine.sharedInstance.userScore) / \(GameEngine.sharedInstance.numberOfQuestionsForGame)"

        if options.value(forKey: "Progress") as! Bool == true {
            UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                self.progressBar.frame.size.width = (self.view.frame.size.width / CGFloat(GameEngine.sharedInstance.numberOfQuestionsForGame)) * CGFloat(GameEngine.sharedInstance.currentQuestionIndex)
            }, completion: nil)
        }
        
        if (count != 0) {
            for _ in 0..<count {
               addNextCard()
                
            }
        }
    }
    
    
    @objc func updateTimer() {
        counter += 0.1
        timerLabel.text = String(format: "%.1f" , counter)
    }
    
    
    @objc func wordCardViewPanned(recognizer : UIPanGestureRecognizer) {

        switch recognizer.state {
            
        case .began:
            let translation = recognizer.translation(in: wordCardView)
            if translation.x > 0 {animateSwipe(direction: .right)}
            else { animateSwipe(direction: .left) }
            animator.pauseAnimation()
            animateProgress = animator.fractionComplete
            
        case .changed:
            
            let translation = recognizer.translation(in: wordCardView)
            var fraction = translation.x / (view.frame.width)
            if currentSwipeDirection == .left { fraction *= -1 }
            animator.fractionComplete = fraction + animateProgress
            if animator.fractionComplete == CGFloat(0) {
                if currentSwipeDirection == .left && translation.x > 0 {
                    refreshAnimator(direction: .right)
                }
                else if currentSwipeDirection == .right && translation.x < 0 {
                    refreshAnimator(direction: .left)
                }
            }
            
        case .ended:
            let velocity = recognizer.velocity(in: wordCardView)
            //If more than 0.4 is complete, do completion block and remove
            if velocity.x > 90 || velocity.x < -90 || animator.fractionComplete > 0.5 {
                animator.addCompletion {(position) in
                    
                    var pickedAnswer: Bool = true

                    if velocity.x < 0 { pickedAnswer = false }
                    
                    if (GameEngine.sharedInstance.checkAnswer(pickedAnswer: pickedAnswer)) {
                        
                        self.revealAndHidePopup(forCorrect: true)
                        
                    }
                    // Check if sudden death is enabled
                    else if self.options.bool(forKey: kSuddenDeathKey) {
                        self.revealAndHidePopup(forCorrect: false)
                        self.wordCardView.removeFromSuperview()
                        self.finishGame()
                        return
                    }
                    else {
                        self.revealAndHidePopup(forCorrect: false)
                    }

                    //Remove answered card from view
                    self.wordCardView.removeFromSuperview()
                    GameEngine.sharedInstance.goToNextQuestion()
                    
                    //Check if quiz has finished!
                    if GameEngine.sharedInstance.isGameFinished() {
                        self.finishGame()
                    }
                    else{
                        self.updateUI(withNewCards: 1)
                    }
                }
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                break
            }
            animator.isReversed = true
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            
        default:
            break
        }
    }
    
    func finishGame() {
        self.timer.invalidate()
                               
       //Darken background view and back button
       UIView.animate(withDuration: 0.7, animations: {
           self.view.backgroundColor = self.view.backgroundColor?.darken(byPercentage: 0.4)
           self.scoreLabel.alpha = 0
           self.progressBar.frame.size.width = self.view.frame.size.width
           self.progressBar.backgroundColor = self.progressBar.backgroundColor?.darken(byPercentage: 0.4)
       })
       self.updateUI(withNewCards: 0)
       //Delay finish popup to show +1 label
       DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
           self.gameFinishedPopup()
       })
    }
    
    func revealAndHidePopup(forCorrect correct:Bool) {

        if (correct) {
            
            UIView.animate(withDuration: 0.4, animations: {
                self.correctPopup.alpha = 1
               self.scoreLabel.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: 0.2, animations: {
                self.correctPopup.alpha = 0
                self.scoreLabel.alpha = 1
                }, completion: nil)
            }
        }
        else {
            UIView.animate(withDuration: 0.4, animations: {
                self.incorrectPopup.alpha = 1
            }) { (success) in
                UIView.animate(withDuration: 0.2, animations: {
                self.incorrectPopup.alpha = 0
                }, completion: nil)
            }
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
            
            //Animate alphas for masculine and feminine labels
            
            if self.currentSwipeDirection == .right { self.wordCardView.masculineLabel.alpha = 0.8 }
            else if self.currentSwipeDirection == .left { self.wordCardView.feminineLabel.alpha = 0.8 }
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
    
    func addNextCard() {
    
        wordCardView = UINib(nibName: "WordCardView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? WordCardView
        
        wordCardView.frame = CGRect(x: 30, y: (view.frame.height - CGFloat(290)) / 2 , width: view.frame.width - CGFloat(60), height: 290)
        
        if !GameEngine.sharedInstance.showHints {
            wordCardView.hintLabel.alpha = 0
        }
        
        let currentQuestionNumber = GameEngine.sharedInstance.currentQuestionIndex
        
        wordCardView.wordLabel.text = GameEngine.sharedInstance.gameWords[currentQuestionNumber].word
        
        wordCardView.hintLabel.text = GameEngine.sharedInstance.gameWords[currentQuestionNumber].hint
        
        wordCardView.addGestureRecognizer(panRecognizer)
        
        wordCardView.isUserInteractionEnabled = true
        
        //Hide and shrink card before showing with animation
        wordCardView.alpha = 0
        wordCardView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
         
        view.addSubview(wordCardView)
        
        UIView.animate(withDuration: 0.2) {
            self.wordCardView.alpha = 1
            self.wordCardView.transform = CGAffineTransform.identity
        }
        
    }
        
    
    func createNewCard() {
        
        wordCardView = UINib(nibName: "WordCardView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? WordCardView
        
        wordCardView.frame = CGRect(x: 30, y: (view.frame.height - CGFloat(290)) / 2 , width: view.frame.width - CGFloat(60), height: 290)
        
        if options.value(forKey: "Hints") as! Bool == false {
            
            wordCardView.hintLabel.alpha = 0
        }
        
        view.addSubview(wordCardView)
        
        wordCardView.addGestureRecognizer(panRecognizer)
        
        wordCardView.isUserInteractionEnabled = true
        
        //Hide and shrink card before showing with animation
        wordCardView.alpha = 0
        wordCardView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
      
        
        UIView.animate(withDuration: 0.2) {
            
            //Reverse fading and shrinking
            self.wordCardView.alpha = 1
            
            self.wordCardView.transform = CGAffineTransform.identity
        
        }
    }
    
    func gameFinishedPopup() {
        
        addGameFinishedView()
        
        updateUserStats()
        
        setupGameFinishedView()
    }
    
    func updateUserStats() {
        
        let incorrectCount: Int = (GameEngine.sharedInstance.numberOfQuestionsForGame - GameEngine.sharedInstance.userScore)
        let newIncorrectCount: Int = options.integer(forKey: "incorrectCount") + incorrectCount
        let newCorrectCount: Int = options.integer(forKey: "correctCount") + GameEngine.sharedInstance.userScore
        options.set(newIncorrectCount, forKey: "incorrectCount")
        options.set(newCorrectCount, forKey: "correctCount")
        
        SessionManager.sharedInstance.registerNewSessionWith(withScore: Int32(GameEngine.sharedInstance.userScore), outOf: Int32(GameEngine.sharedInstance.numberOfQuestionsForGame))
    }
    
    func addGameFinishedView() {
        gameFinishedView = UINib(nibName: "GameFinishedView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? GameFinishedView
        
        gameFinishedView.frame = CGRect(x: 30, y: (view.frame.height - CGFloat(290)) / 2 , width: view.frame.width - CGFloat(60), height: 290)
        
        view.addSubview(gameFinishedView)
    }
    
    func setupGameFinishedView() {
        let wpm = ( Double(GameEngine.sharedInstance.numberOfQuestionsForGame) / counter ) * 60.0
        let percentage = String(format: "%.1f" , (Double(GameEngine.sharedInstance.userScore) / Double(GameEngine.sharedInstance.gameWords.count)) * 100.0)
        gameFinishedView.correctAnswers.text = "Score: \(GameEngine.sharedInstance.userScore) / \(GameEngine.sharedInstance.gameWords.count)"
        gameFinishedView.percentage.text = "Pourcentage: " + percentage + "%"
        gameFinishedView.chrono.text = "Chrono: " + String(format: "%.1f" , counter) + " s"
        gameFinishedView.wpm.text = "MPM: " + String(format: "%.1f" , wpm)
        
        gameFinishedView.alpha = 0
        gameFinishedView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        UIView.animate(withDuration: 0.4) {
            self.timerLabel.alpha = 0
            self.scoreLabel.alpha = 0
            self.gameFinishedView.alpha = 1
            self.gameFinishedView.transform = .identity
//            self.scoreLabel.alpha = 0
//            self.view.backgroundColor = self.view.backgroundColor?.darken(byPercentage: 0.7)
            self.restartButton.alpha = 1
        }
                
    }
    
    @IBAction func restartPressed(_ sender: UIButton) {
        
        GameEngine.sharedInstance.restartGame(withNewWords: true)
        
        counter = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            
            //Move gameFinishedView off screen
            let transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
            //Combine previous transform with rotation
            self.gameFinishedView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 8)).concatenating(transform)
            
            self.restartButton.alpha = 0
            self.scoreLabel.alpha = 1
            self.timerLabel.alpha = 1
            
            //Lighten background and progress bar to normal
            self.view.backgroundColor = self.view.backgroundColor?.lighten(byPercentage: 0.4)
            self.progressBar.backgroundColor = self.progressBar.backgroundColor?.lighten(byPercentage: 0.4)
            
        }) { (success) in
            
            //And remove from SuperView
            self.gameFinishedView.removeFromSuperview()

            self.updateUI(withNewCards: 1)
            
            ///////////////////////////////////////////////////////
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
            }
        }
    }

    
}
