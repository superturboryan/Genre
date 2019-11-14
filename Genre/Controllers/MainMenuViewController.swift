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
    @IBOutlet weak var wordListButton: UIButton!
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var statsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let sessions: [Session] = SessionManager.sharedInstance.getAllSessions()

        showMenu(WithDelay: 0.3)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setupView() {
        
        self.view.setupGradientBG(withFrame: self.view.frame)
        
        //Set soft corners
       menuView.layer.cornerRadius = CGFloat(15.0)
       startGameButton.layer.cornerRadius = CGFloat(5.0)
       statsButton.layer.cornerRadius = CGFloat(5.0)
       wordListButton.layer.cornerRadius = CGFloat(5.0)
        
        //Set button label language
        startGameButton.setTitle(options.bool(forKey: "FrenchLanguage") == true ?
            "Commencer":"Start", for: .normal)
        statsButton.setTitle(options.bool(forKey: "FrenchLanguage") == true ?
            "Statistiques":"Stats" , for: .normal)
        wordListButton.setTitle(options.bool(forKey: "FrenchLanguage") == true ?
            "Vocabulaire":"Word List" , for: .normal)
        
//        self.view.bringSubviewToFront(self.menuView)
    }
    
    
    
    @IBAction func startPressed(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            // Transform similar to card swipe animation
            let transform = CGAffineTransform(translationX: self.view.frame.width*1.1, y: 0)
            self.menuView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 8)).concatenating(transform)
        }) { (completion) in
            if (completion) {
                self.performSegue(withIdentifier: "goToOptions", sender: nil)
            }
        }

    }
    

    
    @IBAction func wordListPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "goToWordList", sender: nil)
    }
    
    
    @IBAction func statsPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "goToStats", sender: nil)
    }
    
    
    @IBAction func languageButtonPressed(_ sender: UIButton) {
        
        guard let currentLang = options.value(forKey: "FrenchLanguage") as? Bool
            else {fatalError()}
        
        options.set(!currentLang, forKey: "FrenchLanguage")
        
        hideMenu()
        
        changeLabelLanguage()
        
        showMenu(WithDelay: 0.8)
    }
    
    //UI animation functions
    
    func hideMenu() {
        
        UIView.animate(withDuration: 0.55, delay: 0, options: .curveEaseOut, animations: {
            self.menuView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height)
//            self.view.backgroundColor = self.view.backgroundColor?.darken(byPercentage: 0.1)
        }, completion: nil)
       
    }
    
    func showMenu(WithDelay delay:Double) {
        UIView.animate(withDuration: 0.8, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                    
                    self.menuView.transform = CGAffineTransform.identity
                    //Lighten background
        //            self.view.backgroundColor = self.view.backgroundColor?.lighten(byPercentage: 0.1)
                    //Add shadow to menu
                    self.menuView.layer.shadowColor = UIColor.black.cgColor
                    self.menuView.layer.shadowOpacity = 0.4
                    self.menuView.layer.shadowOffset = CGSize.zero
                    self.menuView.layer.shadowRadius = CGFloat(12)
                    
                }, completion: nil)
    }
    
    func changeLabelLanguage() {
        
        guard let currentLanguageIsFrench = options.value(forKey: "FrenchLanguage") as? Bool
            else {fatalError()}
        
        if (currentLanguageIsFrench == true) {
            
            startGameButton.setTitle("Commencer", for: .normal)
            statsButton.setTitle("Statistiques", for: .normal)
            wordListButton.setTitle("Vocabulaire", for: .normal)
        }
        else{
            startGameButton.setTitle("Start", for: .normal)
            statsButton.setTitle("Stats", for: .normal)
            wordListButton.setTitle("Word List", for: .normal)
        }
    }
    
    
}

extension UIView {
    func setupGradientBG(withFrame frame:CGRect) {
        let gradient = CAGradientLayer()
        let colorTop = UIColor(hexString: "00b4db")
        let colorBottom = UIColor(hexString: "0083b0")
        gradient.colors = [colorTop?.cgColor,colorBottom?.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.frame = frame
        self.layer.insertSublayer(gradient, at: 0)
    }
}
