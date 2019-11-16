//
//  MainMenuViewController.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-03-14.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit
import ChameleonFramework

protocol MainMenuDelegate {
    func showButtons()
    func hideButtons()
    func shrinkMenu()
}

let kSuddenDeathKey = "SuddenDeath"

class MainMenuViewController: UIViewController, MainMenuDelegate {

    let options = UserDefaults.standard
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var wordListButton: UIButton!
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var statsButton: UIButton!
    
    //Constraints
    @IBOutlet var menuViewHeight: NSLayoutConstraint!
    @IBOutlet var menuViewWidth: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        hideMenu(toTheRight: false,withAnimation: false,thenDo: {})
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        showMenu(WithDelay: 0.3)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setupView() {
        
        self.view.setupGradientBG(withFrame: self.view.frame)

       menuView.layer.cornerRadius = CGFloat(15.0)
       startGameButton.layer.cornerRadius = CGFloat(5.0)
       statsButton.layer.cornerRadius = CGFloat(5.0)
       wordListButton.layer.cornerRadius = CGFloat(5.0)
        
        setupForLanguage()
        
        //iPad sizing
        if (UIScreen.main.bounds.size.height >= 834) {
            menuViewWidth.constant = 375.0
            menuViewHeight.constant = 550.0
        }
    }
    
    func setupForLanguage() {
        startGameButton.setTitle(options.bool(forKey: "FrenchLanguage") == true ?
            "Commencer":"Start", for: .normal)
        statsButton.setTitle(options.bool(forKey: "FrenchLanguage") == true ?
            "Statistiques":"Stats" , for: .normal)
        wordListButton.setTitle(options.bool(forKey: "FrenchLanguage") == true ?
            "Vocabulaire":"Word List" , for: .normal)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {

            return UIStatusBarStyle.default
        
    }
    
    @IBAction func startPressed(_ sender: UIButton) {
        hideMenu(toTheRight:true,withAnimation: true,thenDo: {
            self.performSegue(withIdentifier: "goToOptions", sender: nil)
        })
    }

    @IBAction func wordListPressed(_ sender: UIButton) {
        
        expandMenu {
            self.performSegue(withIdentifier: "goToWordList", sender: nil)
        }
    }
    
    @IBAction func statsPressed(_ sender: UIButton) {
        expandMenu {
        self.performSegue(withIdentifier: "goToStats", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WordListViewController {
            destination.delegate = self
        }
        if let destination = segue.destination as? StatsViewController {
            destination.delegate = self
        }
    }
    
    
    @IBAction func languageButtonPressed(_ sender: UIButton) {
        
        guard let currentLang = options.value(forKey: "FrenchLanguage") as? Bool
            else {fatalError()}
        options.set(!currentLang, forKey: "FrenchLanguage")
        hideMenu(toTheRight:false,withAnimation: true,thenDo: {})
        changeLabelLanguage()
        showMenu(WithDelay: 0.8)
    }
    
    //UI animation functions
    
    func hideMenu(toTheRight direction:Bool, withAnimation animated:Bool, thenDo completion: @escaping CompletionHandler) {
        
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
    
    func showMenu(WithDelay delay:Double) {
        UIView.animate(withDuration: 0.8, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    
                    self.menuView.transform = CGAffineTransform.identity
                    self.menuView.layer.shadowColor = UIColor.black.cgColor
                    self.menuView.layer.shadowOpacity = 0.4
                    self.menuView.layer.shadowOffset = CGSize.zero
                    self.menuView.layer.shadowRadius = CGFloat(12)
                    
                }, completion: nil)
    }
    
    func expandMenu(thenDo: @escaping CompletionHandler) {
        
        self.menuViewHeight.constant = self.view.frame.size.height*1.05
        self.menuViewWidth.constant = self.view.frame.size.width*1.05
        hideButtons()
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            thenDo()
        }
    }
    
    func shrinkMenu() {
        self.menuViewHeight.constant = 450.0
        self.menuViewWidth.constant = 285.0
        //iPad sizing
        if (UIScreen.main.bounds.size.height >= 834) {
            self.menuViewWidth.constant = 375.0
            self.menuViewHeight.constant = 550.0
        }
        UIView.animate(withDuration: 1.2, delay: 0.1, usingSpringWithDamping: 0.55, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            return
        }
    }
    
    func hideButtons() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            self.startGameButton.alpha = 0
            self.statsButton.alpha = 0
            self.wordListButton.alpha = 0
            self.iconButton.alpha = 0
        }) { (success) in
            return
        }
    }
    
    func showButtons() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            self.startGameButton.alpha = 1
            self.statsButton.alpha = 1
            self.wordListButton.alpha = 1
            self.iconButton.alpha = 1
        }) { (success) in
            return
        }
    }
    
    func changeLabelLanguage() {
        
        guard let currentLanguageIsFrench = options.value(forKey: "FrenchLanguage") as? Bool
            else {fatalError()}
        
        if (currentLanguageIsFrench == true) {
            startGameButton.setTitle("Commencer", for: .normal)
            statsButton.setTitle("Statistiques", for: .normal)
            wordListButton.setTitle("Vocabulaire", for: .normal)
        }
        else {
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

