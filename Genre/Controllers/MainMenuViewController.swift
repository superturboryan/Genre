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

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.8, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
            
            self.menuView.transform = CGAffineTransform.identity
            //Lighten background
            self.view.backgroundColor = self.view.backgroundColor?.lighten(byPercentage: 0.33)
            //Add shadow to menu
            self.menuView.layer.shadowColor = UIColor.black.cgColor
            self.menuView.layer.shadowOpacity = 0.4
            self.menuView.layer.shadowOffset = CGSize.zero
            self.menuView.layer.shadowRadius = CGFloat(12)
            
        }) { (success) in
            
            UIView.animate(withDuration: 0.2, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            self.performSegue(withIdentifier: "goToGame", sender: nil)
        }
    }
    
    
    @IBAction func optionsPressed(_ sender: UIButton) {
        
        hideMenu()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            self.performSegue(withIdentifier: "goToOptions", sender: nil)
        }
    }
    
    
    func hideMenu() {
       
        UIView.animate(withDuration: 0.4) {
            
            self.menuView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height)
            self.view.backgroundColor = self.view.backgroundColor?.darken(byPercentage: 0.33)
        }
    }
    
    
    func loadOptions() {
        
        if options.bool(forKey: "Hints") != true && options.bool(forKey: "Hints") != false {
            
            options.set(false, forKey: "Hints")
        }
    }
    
    
    
    
    
    
    

}
