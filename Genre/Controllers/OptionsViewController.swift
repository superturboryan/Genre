//
//  OptionsViewController.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-03-15.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var hintsSwitch: UISwitch!
    @IBOutlet weak var timerSwitch: UISwitch!
    @IBOutlet weak var progressBarSwitch: UISwitch!
    @IBOutlet var suddenDeathSwitch: UISwitch!
    @IBOutlet weak var numOfWordsSlider: UISlider!
    @IBOutlet var newWordsButton: UIButton!
    @IBOutlet var sameWordsButton: UIButton!
    
    @IBOutlet var optionsMenuWidth: NSLayoutConstraint!
    @IBOutlet var optionsMenuHeight: NSLayoutConstraint!

    @IBOutlet weak var hintsLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var numOfWords: UILabel!
    @IBOutlet weak var numOfWordsLabel: UILabel!
    @IBOutlet var suddenDeathLabel: UILabel!

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide menu view on load
        hideOptionsMenu(toTheRight:false, withAnimation: false) { }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupView()
        
        showOptionsMenu()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        presentOnboarding()
    }
    
    //MARK: Setup view
    func setupView() {
        
        hideNavBar()
        addMenuShadow()
        self.menuView.layer.cornerRadius = 15.0
        
        setupToggles()
        setupLabels()
        
        sameWordsButton.isEnabled = GameEngine.sharedInstance.gameWords.count != 0

        //Rounded corner buttons
        newWordsButton.layer.cornerRadius = 7.0;
        sameWordsButton.layer.cornerRadius = 7.0;

        self.view.setupGradientBG(withFrame: self.view.bounds)
        
        //iPad sizing
        if (UIScreen.main.bounds.size.height >= 834) {
            optionsMenuWidth.constant = 375.0
            optionsMenuHeight.constant = 550.0
        }
    }
    
    func setupLabels() {
        //Set label language
        hintsLabel.text = options.bool(forKey: kFrenchLanguage) == true ? "Conseils:":"Hints:"
        timerLabel.text = options.bool(forKey: kFrenchLanguage) == true ? "Chrono:":"Timer:"
        progressLabel.text = options.bool(forKey: kFrenchLanguage) == true ? "Progrès:":"Progress Bar:"
        numOfWordsLabel.text = options.bool(forKey: kFrenchLanguage) == true ? "# de mots:":"Word Count:"
        suddenDeathLabel.text = options.bool(forKey: kFrenchLanguage) == true ? "Mort soudain:":"Sudden death:"
    }
    
    func addMenuShadow() {
        menuView.layer.shadowColor = UIColor.black.cgColor
        menuView.layer.shadowOpacity = 0.4
        menuView.layer.shadowOffset = CGSize.zero
        menuView.layer.shadowRadius = CGFloat(12)
    }
    
    //MARK: Hide+Show Menu
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

        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        hideOptionsMenu(toTheRight: false, withAnimation: true) {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    //MARK: Toggles
    func setupToggles() {

        guard let hintOption = options.value(forKey: kHints) as? Bool else {print("Error loading User Defaults"); return;}
        hintsSwitch.isOn = hintOption
        guard let timerOption = options.value(forKey: kTimer) as? Bool else {print("Error loading User Defaults"); return;}
        timerSwitch.isOn = timerOption
        guard let progressOption = options.value(forKey: kProgress) as? Bool else {print("Error loading User Defaults"); return;}
        progressBarSwitch.isOn = progressOption
        guard let suddenDeathOption = options.value(forKey: kSuddenDeath) as? Bool else {print("Error loading User Defaults"); return;}
        suddenDeathSwitch.isOn = suddenDeathOption
        guard let wordCountOption = options.value(forKey: kWordCount) as? Int else {print("Error loading User Defaults"); return;}
        numOfWords.text = String(wordCountOption)
        numOfWordsSlider.value = Float(wordCountOption)
    }
    
    @IBAction func hintsPressed(_ sender: UISwitch) {
        options.set(sender.isOn, forKey: kHints)
    }
    
    @IBAction func timerPressed(_ sender: UISwitch) {
         options.set(sender.isOn, forKey: kTimer)
    }
    
    @IBAction func progressPressed(_ sender: UISwitch) {
        options.set(sender.isOn, forKey: kProgress)
    }
    
    @IBAction func suddenDeathPressed(_ sender: UISwitch) {
        options.set(sender.isOn, forKey: kSuddenDeath)
    }
    
    @IBAction func numOfWordsSet(_ sender: UISlider) {
        numOfWords.text = String(Int(sender.value))
        options.set(Int(sender.value), forKey: "WordCount")
    }
    
    //MARK: IBActions
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
    
    func presentOnboarding() {
        
//        let overlay = CAShapeLayer()
//        let circle = CAShapeLayer()
//        overlay.path = CGPath.init(rect: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), transform: nil)
//        overlay.backgroundColor = UIColor.clear.cgColor
//        overlay.fillColor = UIColor.clear.cgColor
//        overlay.mask = circle
//
////        let radius: CGFloat = myRect.size.width
//        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height), cornerRadius: 0)
//        let circlePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2 * radius, height: 2 * radius), cornerRadius: radius)
//        path.append(circlePath)
//        path.usesEvenOddFillRule = true
//
//        let fillLayer = CAShapeLayer()
//        fillLayer.path = path.cgPath
//        fillLayer.fillRule = .evenOdd
//        fillLayer.fillColor = view.backgroundColor?.cgColor
//        fillLayer.opacity = 0.5
//        view.layer.addSublayer(fillLayer)
//
//        self.view.layer.addSublayer(overlay)
//        self.view.layer.addSublayer(circle)
        
//        let bgFadeIn = CABasicAnimation(keyPath: "fillColor")
//        bgFadeIn.duration = 1.0
//        bgFadeIn.fromValue = UIColor.clear.cgColor
//        bgFadeIn.toValue = UIColor.colorWithRedValue(redValue: 35, greenValue: 35, blueValue: 35, alpha: 0.6).cgColor
//        bgFadeIn.isRemovedOnCompletion = false
//        bgFadeIn.fillMode = CAMediaTimingFillMode.forwards
//        overlay.addAnimation(bgFadeIn, forKey: bgFadeIn.keyPath, withCompletion: nil)
        
        // Create a view filling the screen.
        let overlay = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

        // Set a semi-transparent, black background.
        overlay.backgroundColor = UIColor(red: 25, green: 25, blue: 25, alpha: 0.5)

        // Create the initial layer from the view bounds.
        let maskLayer = CAShapeLayer()
        maskLayer.frame = overlay.bounds
        maskLayer.fillColor = UIColor.black.cgColor

        // Create the frame for the circle.
        let radius: CGFloat = 50.0
        let rect = CGRect(
            x: overlay.frame.midX - radius,
            y: overlay.frame.midY - radius,
            width: 2 * radius,
            height: 2 * radius)

        // Create the path.
        let path = UIBezierPath(rect: overlay.bounds)
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd

        // Append the circle to the path so that it is subtracted.
        path.append(UIBezierPath(ovalIn: rect))
        maskLayer.path = path.cgPath

        // Set the mask of the view.
        overlay.layer.mask = maskLayer

        // Add the view so it is visible.
        self.view.addSubview(overlay)
    }
    
}

extension UIColor {
    
    static func colorWithRedValue(redValue: CGFloat, greenValue: CGFloat, blueValue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: redValue/255.0, green: greenValue/255.0, blue: blueValue/255.0, alpha: alpha)
    }
}
