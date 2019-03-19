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
    
    
    let options = UserDefaults.standard
    
    var hintOption : Bool = false
    
    var timerOption : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hintOption = options.value(forKey: "Hints") as! Bool
        
        hintsSwitch.isOn = hintOption
        
        timerOption = hintOption
        
        timerSwitch.isOn = timerOption
        
        menuView.layer.cornerRadius = CGFloat(7.0)

        menuView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.8, delay: 0.4, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
            
            self.menuView.transform = CGAffineTransform.identity
            
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
    
    
    
    func addMenuShadow() {
        
        menuView.layer.shadowColor = UIColor.black.cgColor
        menuView.layer.shadowOpacity = 0.4
        menuView.layer.shadowOffset = CGSize.zero
        menuView.layer.shadowRadius = CGFloat(12)
    }
    
    

}
