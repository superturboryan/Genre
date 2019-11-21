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
        
        presentOnboarding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupView()
        
        showOptionsMenu()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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

    var overlay = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var currentCircleRect = CGRect()
    
    func presentOnboarding() {
        
        overlay.backgroundColor = UIColor.colorWith(r: 15, g: 15, b: 15, a: 0.85)

        let maskLayer = CAShapeLayer()
        maskLayer.frame = overlay.bounds
        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        let radius: CGFloat = 50.0
 
        let bigPath = getRoundRectBezierForRect(CGRect(
        x: self.numOfWordsLabel.frame.minX+radius-15,
        y: self.numOfWordsLabel.frame.maxY+radius+10,
        width: 8 * radius,
        height: 8 * radius))
        
        let firstLabelPath = getRoundRectBezierForRect(CGRect(
        x: self.numOfWordsLabel.frame.minX+radius-15,
        y: self.numOfWordsLabel.frame.maxY+radius+10,
        width: 2 * radius,
        height: 2 * radius))
        
        let secondLabelPath = getRoundRectBezierForRect(CGRect(
        x: self.hintsLabel.frame.minX+radius-25,
        y: self.hintsLabel.frame.maxY+radius-10,
        width: 2 * radius,
        height: 2 * radius))
        
        let thirdLabelPath = getRoundRectBezierForRect(CGRect(
        x: self.timerLabel.frame.minX+radius-25,
        y: self.timerLabel.frame.maxY+radius-10,
        width: 2 * radius,
        height: 2 * radius))
        
        maskLayer.path = bigPath.cgPath
        
        // Set the mask of the view.
        overlay.layer.mask = maskLayer
        
        let circleShrink = getAnimationFromPathToPath(from: bigPath, to: firstLabelPath, withDuration: 0.6)
        let circleMove1 = getAnimationFromPathToPath(from: firstLabelPath, to: secondLabelPath, withDuration: 1.0)
        let circleMove2 = getAnimationFromPathToPath(from: secondLabelPath, to: thirdLabelPath, withDuration: 1.0)
        
        let numWordsText = "Move the slider to set the quiz length"
        let hintsText = "Turn on hints to get tips about spotting the noun's gender"
        let timerText = "Turn on the timer to see a counter showing you how long you're taking"

        self.animateBezierPath(forLayer: maskLayer, withAnimation: circleShrink, withDelay: 0.0) {
            
            self.fadeInAndOutLabel(inView: self.overlay, withText: numWordsText, positionNextToView:self.numOfWordsLabel, afterDelay: 1.0) {
                    
                self.animateBezierPath(forLayer: maskLayer, withAnimation: circleMove1, withDelay: 0.0) {
                    
                    self.fadeInAndOutLabel(inView: self.overlay, withText: hintsText, positionNextToView:self.hintsLabel, afterDelay: 0.2) {
                        
                        self.animateBezierPath(forLayer: maskLayer, withAnimation: circleMove2, withDelay: 0.0) {
                            
                            self.fadeInAndOutLabel(inView: self.overlay, withText: timerText, positionNextToView:self.timerLabel, afterDelay: 0.2) {
                                
                                UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveEaseInOut, animations: {
                                    self.overlay.alpha = 0
                                }) { (success) in
                                    self.overlay.removeFromSuperview()
                                }
                            }
                            
                        }
                    }
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.view.addSubview(self.overlay)
        }
    }
    
    func fadeInAndOutLabel(inView:UIView, withText text:String, positionNextToView view:UIView, afterDelay delay:Double, thenDo: @escaping CompletionHandler) {
        
        let labelFrame = self.menuView.convert(view.frame, to: inView)
        
        let label = UILabel(frame: CGRect(x: labelFrame.maxX + 15, y: labelFrame.maxY, width: 150, height: 100))
        label.text = text
        label.textColor = .white
        label.numberOfLines = 0
        label.alpha = 0
        
        inView.addSubview(label)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                label.alpha = 1.0
            }) { (success) in
                UIView.animate(withDuration: 0.3, delay: 5.0, options: .curveEaseInOut, animations: {
                    label.alpha = 0.0
                }) { (success) in
                    label.removeFromSuperview()
                    thenDo()
                }
            }
        }
        
    }
    
    func getRoundRectBezierForRect(_ rect:CGRect) -> UIBezierPath {
        let rect = rect
        let path = UIBezierPath(rect: self.overlay.bounds)
        path.append(UIBezierPath(ovalIn: rect))
        return path
    }
    
    func getAnimationFromPathToPath(from:UIBezierPath, to:UIBezierPath, withDuration duration:Double) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = from.cgPath
        animation.toValue = to.cgPath
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        return animation
    }
    
    func animateBezierPath(forLayer layer:CAShapeLayer, withAnimation animation:CABasicAnimation, withDelay delay:Double, thenDo: @escaping CompletionHandler) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            layer.addAnimation(animation, forKey: "path") { (success) in
                
                thenDo()
            }
        }
    }
    
}

extension UIColor {
    
    static func colorWith(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
}
