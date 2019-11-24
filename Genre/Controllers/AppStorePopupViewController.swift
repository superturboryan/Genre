//
//  AppStorePopupViewController.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-11-17.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit

class AppStorePopupViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var handLabel: UILabel!
    @IBOutlet weak var middleTextLabel: UILabel!
    @IBOutlet weak var positiveAnswerButton: UIButton!
    @IBOutlet weak var negativeAnswerButton: UIButton!
    
    var viewCount = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewCount == 1 {
            self.dismiss(animated: true, completion: nil)
        }
        
        viewCount += 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
           self.performHandShake()
        }
    }
    
    func setupView() {
        self.positiveAnswerButton.layer.cornerRadius = 15
        self.negativeAnswerButton.layer.cornerRadius = 15
    }

    @IBAction func positiveButtonPressed(_ sender: UIButton) {
        AppStoreReviewManager.sharedInstance.presentPopupIfAppropriate()
        options.set(true, forKey: kHasPresentedAppleReviewPopup)
    }
    
    @IBAction func negativeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func performHandShake() {
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = 0.4
        animation.repeatCount = 3
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.autoreverses = true
        animation.fromValue = -20 * Double.pi / 180
        animation.toValue = 20 * Double.pi / 180
        animation.isRemovedOnCompletion = false

        self.handLabel.layer.add(animation, forKey: "position")
        
    }
    
}

