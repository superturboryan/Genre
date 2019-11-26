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
    func showMenu(WithDelay:Double)
}

protocol LanguageChange {
    func updateLanguageLabels()
}

class MainMenuViewController: UIViewController, MainMenuDelegate, LanguageChange {

    //MARK: Outlets
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var wordListButton: UIButton!
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var statsButton: UIButton!
    
    @IBOutlet var menuViewHeight: NSLayoutConstraint!
    @IBOutlet var menuViewWidth: NSLayoutConstraint!
    
    var delegate: UIPopoverPresentationControllerDelegate?
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupGradientBG()
        
        hideMenu(toTheRight: false,withAnimation: false,thenDo: {})
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showMenu(WithDelay: 0.3)
        
        AppStoreReviewManager.sharedInstance.checkIfReviewShouldBeRequested()
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         setupView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK:Setup UI
    func setupView() {
        
        self.view.setupGradientBG(withFrame: self.view.frame)

        iconButton.layer.cornerRadius = CGFloat(15.0)
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
    
    //MARK: IB Actions
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
    
    
    @IBAction func languageButtonPressed(_ sender: UIButton) {
        
        guard let currentLang = options.value(forKey: "FrenchLanguage") as? Bool
            else {fatalError()}
        options.set(!currentLang, forKey: "FrenchLanguage")
        hideMenu(toTheRight:false,withAnimation: true,thenDo: {})
        updateLanguageLabels()
        showMenu(WithDelay: 0.8)
    }
    
    //MARK:Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? OptionsViewController {
            destination.delegate = self
        }
        
        if let destination = segue.destination as? WordListViewController {
            destination.delegate = self
        }
        
        if let destination = segue.destination as? StatsViewController {
            destination.delegate = self
        }
    }
    
    //MARK:UI animation functions
    
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
    
    func updateLanguageLabels() {
        
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
    
    //MARK: Gradient variables
    let gradient = CAGradientLayer()
    var currentGradient = 0
    var gradientSet = [[CGColor]]()
    
}

extension MainMenuViewController: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        if flag {
            if let colorChange = gradient.value(forKey: "colorChange") as? Int {
                gradient.colors = gradientSet[colorChange]
                animateGradient()
            }
        }
    }
    
    func setupGradientBG() {
        
        let colorTop = UIColor(hexString: "00b4db")?.cgColor
        let colorBottom = UIColor(hexString: "0083b0")?.cgColor
        let thirdColor = UIColor(hexString: "#02AAB0")?.cgColor
        let fourthColor = UIColor(hexString: "#00CDAC")?.cgColor

        gradientSet.append([colorBottom!, colorTop!])
        gradientSet.append([colorTop!, thirdColor!])
        gradientSet.append([thirdColor!, fourthColor!])
        gradientSet.append([fourthColor!, colorBottom!])
        
        gradient.startPoint = CGPoint(x: 0, y: 0)
        
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        gradient.drawsAsynchronously = true
        
        self.view.layer.insertSublayer(gradient, at: 1)
    }
    
    func animateGradient() {
        
        var previousGradient: Int!
        
        if currentGradient < gradientSet.count - 1 {
            
            currentGradient += 1
            
            previousGradient = currentGradient - 1
            
        }
        else {
            
            currentGradient = 0
            
            previousGradient = gradientSet.count - 1
            
        }
        
        let gradientChangeAnim = CABasicAnimation(keyPath: "colors")
        
        gradientChangeAnim.duration = 5.0
        
        gradientChangeAnim.fromValue = gradientSet[previousGradient]
        
        gradientChangeAnim.toValue = gradientSet[currentGradient]
        
        gradient.setValue(currentGradient, forKeyPath: "colorChange")
        
        gradientChangeAnim.fillMode = CAMediaTimingFillMode.forwards
        
        gradientChangeAnim.isRemovedOnCompletion = false
        
        gradientChangeAnim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        gradientChangeAnim.delegate = self
        
        gradient.add(gradientChangeAnim, forKey: nil)
        
    }
}

extension UIView {
    
    func setupGradientBG(withFrame frame:CGRect) {
        
        let gradient = CAGradientLayer()

        let colorTop = UIColor(named: "primary")?.cgColor
        let colorMiddle = UIColor(named: "light")?.cgColor
        let colorBottom = UIColor(named: "dark")?.cgColor
        
        gradient.colors = [colorTop,colorBottom]
        gradient.locations = [0.5,1.0]
        gradient.frame = frame
        self.layer.insertSublayer(gradient, at: 0)
    }
}


