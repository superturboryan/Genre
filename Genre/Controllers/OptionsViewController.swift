//
//  OptionsViewController.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-03-15.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit

typealias CompletionHandler = () -> Void

class OptionsViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var hintsSwitch: UISwitch!
    @IBOutlet weak var timerSwitch: UISwitch!
    @IBOutlet weak var progressBarSwitch: UISwitch!
    @IBOutlet var suddenDeathSwitch: UISwitch!
    @IBOutlet weak var numOfWordsSlider: UISlider!
    @IBOutlet var newWordsButton: UIButton!
    @IBOutlet var sameWordsButton: UIButton!
    
    //Labels

    @IBOutlet weak var hintsLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var numOfWords: UILabel!
    @IBOutlet weak var numOfWordsLabel: UILabel!
    @IBOutlet var suddenDeathLabel: UILabel!
    
    let options = UserDefaults.standard
    
    var hintOption : Bool = false
    
//    var timerOption : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideOptionsMenu(toTheRight:false, withAnimation: false) { }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        hideNavBar()
        setupView()
    }
    
    func setupView() {
        
        setupSameWordsButton()
        
        addMenuShadow()
        
        self.menuView.layer.cornerRadius = 15.0
        
        setupToggles()
        
        //View styling
        menuView.layer.cornerRadius = CGFloat(7.0)
        
        //Set label language

        hintsLabel.text = options.bool(forKey: "FrenchLanguage") == true ? "Conseils:":"Hints:"
        timerLabel.text = options.bool(forKey: "FrenchLanguage") == true ? "Chrono:":"Timer:"
        progressLabel.text = options.bool(forKey: "FrenchLanguage") == true ? "Progrès:":"Progress Bar:"
        numOfWordsLabel.text = options.bool(forKey: "FrenchLanguage") == true ? "# de mots:":"Word Count:"
        suddenDeathLabel.text = options.bool(forKey: "FrenchLanguage") == true ? "Mort soudain:":"Sudden death:"
        
        //Rounded corner buttons
        newWordsButton.layer.cornerRadius = 7.0;
        sameWordsButton.layer.cornerRadius = 7.0;

        self.view.setupGradientBG(withFrame: self.view.bounds)
        
        showOptionsMenu()
    }
    
    func setupToggles() {
        //Set values for switches and slider
        guard let hintOption = options.value(forKey: "Hints") as? Bool else {return}
        
        hintsSwitch.isOn = hintOption
        
        guard let timerOption = options.value(forKey: "Timer") as? Bool else {return}
        
        timerSwitch.isOn = timerOption
        
        guard let progressOption = options.value(forKey: "Progress") as? Bool else {return}
        
        progressBarSwitch.isOn = progressOption
        
        guard let suddenDeathOption = options.value(forKey: "SuddenDeath") as? Bool else {return}
        
        suddenDeathSwitch.isOn = suddenDeathOption
        
        guard let wordCountOption = options.value(forKey: "WordCount") as? Int else {return}
        
        numOfWords.text = String(wordCountOption)
        
        numOfWordsSlider.value = Float(wordCountOption)
    }
    
    func setupSameWordsButton() {
        
        sameWordsButton.isEnabled = GameEngine.sharedInstance.gameWords.count != 0
    }
    
    func hideOptionsMenu(toTheRight direction:Bool, withAnimation animated:Bool, thenDo completion: @escaping CompletionHandler) {
        
        if animated {
            UIView.animate(withDuration: 0.8, delay: 0.1, options: .curveEaseInOut, animations: {
                let transform = CGAffineTransform(translationX: direction ? self.view.frame.width*1.1 : -self.view.frame.width*1.1, y: 0)
                self.menuView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 8)).concatenating(transform)
            }) { (success) in
                completion()
            }
        }
        else {
            // Transform similar to card swipe animation
            let transform = CGAffineTransform(translationX: direction ? self.view.frame.width*1.1 : -self.view.frame.width*1.1, y: 0)
           self.menuView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 8)).concatenating(transform)
        }
    }
    
    func showOptionsMenu() {
        UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.menuView.transform = CGAffineTransform.identity
        }) { (completion) in
            return
        }
    }
    
    func hideNavBar() {
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
//        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
//            // Transform similar to card swipe animation
//            let transform = CGAffineTransform(translationX: self.view.frame.width*1.1, y: 0)
//            self.menuView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 8)).concatenating(transform)
//        }) { (completion) in
//            // DismissVC sans animation because backgrounds are all the same
//            self.navigationController?.popViewController(animated: false)
//        }
//
        hideOptionsMenu(toTheRight: false, withAnimation: true) {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    @IBAction func hintsPressed(_ sender: UISwitch) {
        
        if sender.isOn {
            options.set(true, forKey: "Hints")
            print("Set to on!")
        }
        else {
            options.set(false, forKey: "Hints")
            print("Set to off!")
        }
        
    }
    
    
    @IBAction func timerPressed(_ sender: UISwitch) {
        
        if sender.isOn {
            options.set(true, forKey: "Timer")
        }
        else {
            options.set(false, forKey: "Timer")
        }
        
    }
    
    
    @IBAction func progressPressed(_ sender: UISwitch) {
        
        if sender.isOn {
            options.set(true, forKey: "Progress")
        }
        else {
            options.set(false, forKey: "Progress")
        }
    }
    
    
    @IBAction func suddenDeathPressed(_ sender: UISwitch) {
        if sender.isOn {
            options.set(true, forKey: "SuddenDeath")
        }
        else {
            options.set(false, forKey: "SuddenDeath")
        }
    }
    
    
    @IBAction func numOfWordsSet(_ sender: UISlider) {
        
        numOfWords.text = String(Int(sender.value))
        
        options.set(Int(sender.value), forKey: "WordCount")
    }
    
    func addMenuShadow() {
        
        menuView.layer.shadowColor = UIColor.black.cgColor
        menuView.layer.shadowOpacity = 0.4
        menuView.layer.shadowOffset = CGSize.zero
        menuView.layer.shadowRadius = CGFloat(12)
    }
    
    @IBAction func newWordsPressed(_ sender: UIButton) {
        
        GameEngine.sharedInstance.restartGame(withNewWords: true)
        
        hideOptionsMenu(toTheRight:true, withAnimation: true) {
            self.performSegue(withIdentifier: "goToGame", sender: nil)
        }
    }
    
    @IBAction func sameWordsPressed(_ sender: UIButton) {
        
        GameEngine.sharedInstance.restartGame(withNewWords: false)
        
        hideOptionsMenu(toTheRight:true, withAnimation: true) {
            self.performSegue(withIdentifier: "goToGame", sender: nil)
        }
    }
    
    
}
