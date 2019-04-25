//
//  MainMenuViewController.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-03-14.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit
import ChameleonFramework

class MainMenuViewController: UIViewController {

    let options = UserDefaults.standard
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var hintsButton: UIButton!
    @IBOutlet weak var wordListButton: UIButton!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var iconButton: UIButton!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadOptions()
  
        //Set soft corners
        menuView.layer.cornerRadius = CGFloat(7.0)
        startGameButton.layer.cornerRadius = CGFloat(5.0)
        hintsButton.layer.cornerRadius = CGFloat(5.0)
        wordListButton.layer.cornerRadius = CGFloat(5.0)
        optionsButton.layer.cornerRadius = CGFloat(5.0)

        //Hide view upon loading
        menuView.transform = CGAffineTransform(scaleX: 0, y: 0 )
        
        //Hide all buttons separately
        startGameButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        hintsButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        wordListButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        optionsButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        iconButton.transform = CGAffineTransform(scaleX: 0, y: 0)

        //Set button label language
        startGameButton.setTitle(options.bool(forKey: "FrenchLanguage") == true ?
            "Commencer":"Start", for: .normal)
        hintsButton.setTitle(options.bool(forKey: "FrenchLanguage") == true ?
            "Conseils":"Hints" , for: .normal)
        wordListButton.setTitle(options.bool(forKey: "FrenchLanguage") == true ?
            "Vocabulaire":"Word List" , for: .normal)
        optionsButton.setTitle(options.bool(forKey: "FrenchLanguage") == true ?
            "Réglages":"Settings", for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
            
            self.menuView.transform = CGAffineTransform.identity
            //Lighten background
            self.view.backgroundColor = self.view.backgroundColor?.lighten(byPercentage: 0.33)
            //Add shadow to menu
            self.menuView.layer.shadowColor = UIColor.black.cgColor
            self.menuView.layer.shadowOpacity = 0.4
            self.menuView.layer.shadowOffset = CGSize.zero
            self.menuView.layer.shadowRadius = CGFloat(12)
            
            //Make buttons pop-up sequentially
            
        }) { (success) in
            
            
            UIView.animate(withDuration: 0.2, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                
                self.startGameButton.transform = CGAffineTransform.identity
                
            }, completion: { (success) in
                
                UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                    
                    self.hintsButton.transform = CGAffineTransform.identity
                    
                }, completion: { (success) in
                    
                    UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                        
                        self.wordListButton.transform = CGAffineTransform.identity
                        
                    }, completion: { (success) in
                        
                        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                            
                            self.optionsButton.transform = CGAffineTransform.identity
                            
                        }, completion: { (success) in
                            
                            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                                
                                self.iconButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                               
                            }, completion: nil)
                        })
                    })
                })
            })
        }
    }
    
    
    @IBAction func startPressed(_ sender: UIButton) {
        
        hideMenu()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.performSegue(withIdentifier: "goToGame", sender: nil)
        }
    }
    
    
    @IBAction func optionsPressed(_ sender: UIButton) {
        
        hideMenu()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            
            self.performSegue(withIdentifier: "goToOptions", sender: nil)
        }
    }
    
    
    @IBAction func languageButtonPressed(_ sender: UIButton) {
        
        guard let currentLang = options.value(forKey: "FrenchLanguage") as? Bool
            else {fatalError()}
        
        options.set(!currentLang, forKey: "FrenchLanguage")
        
        hideMenu()
        
        changeLabelLanguage()
        
        UIView.animate(withDuration: 0.8, delay: 0.8, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
            
            self.menuView.transform = CGAffineTransform.identity
            //Lighten background
            self.view.backgroundColor = self.view.backgroundColor?.lighten(byPercentage: 0.33)
            //Add shadow to menu
            self.menuView.layer.shadowColor = UIColor.black.cgColor
            self.menuView.layer.shadowOpacity = 0.4
            self.menuView.layer.shadowOffset = CGSize.zero
            self.menuView.layer.shadowRadius = CGFloat(12)
            
        }, completion: nil)
        
    }
    
    
    //UI animation functions
    
    func hideMenu() {
        
        UIView.animate(withDuration: 0.5, delay: 0.05, options: .curveEaseOut, animations: {
            self.menuView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height)
            self.view.backgroundColor = self.view.backgroundColor?.darken(byPercentage: 0.33)
        }, completion: nil)
       
    }
    
    func hideButtons() {
        
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
            
            self.startGameButton.transform = CGAffineTransform(scaleX: 0, y: 0)
            
        }, completion: { (success) in
            
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                
                self.hintsButton.transform = CGAffineTransform(scaleX: 0, y: 0)
                
            }, completion: { (success) in
                
                UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                    
                    self.wordListButton.transform = CGAffineTransform(scaleX: 0, y: 0)
                    
                }, completion: { (success) in
                    
                    UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                        
                        self.optionsButton.transform = CGAffineTransform(scaleX: 0, y: 0)
                        
                    }, completion: { (success) in
                        
                        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                            
                            self.iconButton.transform = CGAffineTransform(scaleX: 0, y: 0)
                            
                        }, completion: nil)
                    })
                })
            })
        })
        
    }
    
    func changeLabelLanguage() {
        
        guard let currentLanguageIsFrench = options.value(forKey: "FrenchLanguage") as? Bool
            else {fatalError()}
        
        if (currentLanguageIsFrench == true) {
            
            startGameButton.setTitle("Commencer", for: .normal)
            hintsButton.setTitle("Conseils", for: .normal)
            wordListButton.setTitle("Vocabulaire", for: .normal)
            optionsButton.setTitle("Réglages", for: .normal)
        }
        else{
            startGameButton.setTitle("Start", for: .normal)
            hintsButton.setTitle("Hints", for: .normal)
            wordListButton.setTitle("Word List", for: .normal)
            optionsButton.setTitle("Settings", for: .normal)
        }
    }
    
    func loadOptions() {
        
        //Set hints to false by default after checking if the first is set
        if options.bool(forKey: "OptionsSet") == false{
            
            options.set(true, forKey: "OptionsSet")
            
            options.set(false, forKey: "Hints")
            options.set(false, forKey: "Timer")
            options.set(true, forKey: "Progress")
            options.set(10, forKey: "WordCount")
            options.set(false, forKey: "FrenchLanguage")
            
            print("Default options set!" + String(options.bool(forKey: "OptionsSet")))
        }
        
        
    }
    
    
    
    
    
    
    

}
