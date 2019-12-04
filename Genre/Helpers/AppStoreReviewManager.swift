//
//  AppStoreReviewManager.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-11-17.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit
import StoreKit

class AppStoreReviewManager: NSObject {
    
    static let sharedInstance = AppStoreReviewManager()
    
    func presentPopupIfAppropriate() {
        
        if options.bool(forKey: kHasPresentedAppleReviewPopup) == false {
          SKStoreReviewController.requestReview()
        }
    }
    
    func checkIfReviewShouldBeRequested() {
        
        if (StatsManager.sharedInstance.getTotalSessionsCount() == 3 || StatsManager.sharedInstance.getTotalSessionsCount() == 10) &&
            options.bool(forKey: kHasPresentedAppleReviewPopup) == false {
         
            if var topController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                
                while let presentedViewController = topController.presentedViewController as? UINavigationController {
                    topController = presentedViewController
                }
                
                let reviewVC = AppStorePopupViewController()
                let navVC = UINavigationController(rootViewController: reviewVC)
                navVC.isNavigationBarHidden = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    topController.present(navVC, animated: true, completion: nil)
                }
            }
        }
    }

}


