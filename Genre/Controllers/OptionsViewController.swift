//
//  OptionsViewController.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-03-15.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit



class OptionsViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var hintsSwitch: UISwitch!
    
    @IBOutlet weak var timerSwitch: UISwitch!
    
    @IBOutlet weak var progressBarSwitch: UISwitch!
    
    @IBOutlet weak var numOfWordsSlider: UISlider!
    
    //Labels
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var hintsLabel: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var numOfWordsLabel: UILabel!
    
    let options = UserDefaults.standard
    
    var hintOption : Bool = false
    
//    var timerOption : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set values for switches and slider
        guard let hintOption = options.value(forKey: "Hints") as? Bool else {return}
        
        hintsSwitch.isOn = hintOption
        
        guard let timerOption = options.value(forKey: "Timer") as? Bool else {return}
        
        timerSwitch.isOn = timerOption
        
        guard let progressOption = options.value(forKey: "Progress") as? Bool else {return}
        
        progressBarSwitch.isOn = progressOption
        
        guard let wordCountOption = options.value(forKey: "WordCount") as? Int else {return}
        
        numOfWordsLabel.text = String(wordCountOption)
        
        numOfWordsSlider.value = Float(wordCountOption)
        
        //View styling
        menuView.layer.cornerRadius = CGFloat(7.0)

        menuView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        
        //Set label language
        
        backButton.setTitle(options.bool(forKey: "FrenchLanguage") == true ?
            "Dernier page":"Back", for: .normal)
        hintsLabel.text = options.bool(forKey: "FrenchLanguage") == true ? "Conseils :":"Hints :"
        timerLabel.text = options.bool(forKey: "FrenchLanguage") == true ? "Chrono :":"Timer :"
        progressLabel.text = options.bool(forKey: "FrenchLanguage") == true ? "Progrès :":"Progress Bar :"
        numOfWordsLabel.text = options.bool(forKey: "FrenchLanguage") == true ? "Numéro de mots :":"Word Count :"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.8, delay: 0.4, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
            
            self.menuView.transform = CGAffineTransform.identity
            print("Menu sliding up!")
            
            //Lighten background
            self.view.backgroundColor = self.view.backgroundColor?.lighten(byPercentage: 0.33)
            
            //Add shadow to menu
            self.addMenuShadow()
            
        }, completion: nil)
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5, delay: 0.05, options: .curveEaseOut, animations: {
            
            self.menuView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height)
            self.view.backgroundColor = self.view.backgroundColor?.darken(byPercentage: 0.33)
        
        }) { (success) in
            
            self.dismiss(animated: true, completion: nil)
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
    
    
    @IBAction func numOfWordsSet(_ sender: UISlider) {
        
        numOfWordsLabel.text = String(Int(sender.value))
        
        options.set(Int(sender.value), forKey: "WordCount")
    }
    
    func addMenuShadow() {
        
        menuView.layer.shadowColor = UIColor.black.cgColor
        menuView.layer.shadowOpacity = 0.4
        menuView.layer.shadowOffset = CGSize.zero
        menuView.layer.shadowRadius = CGFloat(12)
    }
    
    

}
