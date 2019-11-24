//
//  AppDelegate.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-03-13.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.setDefaultOptions()
       
        self.checkIfCsvHasBeenLoadedIntoCoreData()
        
        
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
     
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        self.setupShortcutItems()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
   
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext()
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        handleShortcutAction(shortcutItem.type)
    }
    
    func setupShortcutItems() {
        
        if GameEngine.sharedInstance.gameWords.count > 0 {
            
            let firstItem = UIApplicationShortcutItem(type: "ShortcutItem2", localizedTitle: "Replay game", localizedSubtitle: "With the same words", icon: UIApplicationShortcutIcon(type: .bookmark), userInfo: nil)
            
            UIApplication.shared.shortcutItems?.append(firstItem)
        
        }
        
        if SessionManager.sharedInstance.getAllSessions().count > 0 {
            
            let secondItem = UIApplicationShortcutItem(type: "ShortcutItem4", localizedTitle: "View Stats", localizedSubtitle: "Review past games", icon: UIApplicationShortcutIcon(type: .time), userInfo: nil)
            
            UIApplication.shared.shortcutItems?.append(secondItem)
            
        }
        
    }
    
    func handleShortcutAction(_ type:String) {
        
        let rootNav = self.window?.rootViewController as! UINavigationController
        
        switch type {
            
        case "ShortcutItem1":
            
            GameEngine.sharedInstance.loadNewGameWords()
            let gameVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameVC")
            rootNav.pushViewController(gameVC, animated: false)
            break;
            
        case "ShortcutItem2":
            let gameVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameVC")
            rootNav.pushViewController(gameVC, animated: false)
            break;
            
        case "ShortcutItem3":
            let wordListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WordListVC")
            rootNav.pushViewController(wordListVC, animated: false)
            break;
            
        case "ShortcutItem4":
            let statsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StatsVC")
            rootNav.pushViewController(statsVC, animated: false)
            break;
            
        default:
            break;
            
        }
        
    }
    
    // MARK: - Core Data stack

   lazy var persistentContainer: NSPersistentContainer = {
    
       let container = NSPersistentContainer(name: "WordModel")
       container.loadPersistentStores(completionHandler: { (storeDescription, error) in
           if let error = error as NSError? {
               
               fatalError("Unresolved error \(error), \(error.userInfo)")
           }
       })
       return container
   }()

   // MARK: - Core Data Saving support

   func saveContext () {
       let context = persistentContainer.viewContext
       if context.hasChanges {
           do {
               try context.save()
           } catch {

            
               let nserror = error as NSError
               fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
           }
       }
   }

    func checkIfCsvHasBeenLoadedIntoCoreData() {
        if (!WordManager.sharedInstance.checkIfCSVHasBeenLoaded()) {
            WordManager.sharedInstance.loadCsvIntoCoreData()
        }
        else { print("CSV already loaded into Core Data") }
    }
    
    
    // MARK: Settings
    
    func setDefaultOptions() {
        
         let options = UserDefaults.standard
        
        //Set hints to false by default after checking if the first is set
        if options.bool(forKey: kOptionsSet) == false {
            
            options.set(true, forKey: kOptionsSet)
            
            options.set(false, forKey: kHints)
            options.set(false, forKey: kTimer)
            options.set(true, forKey: kProgress)
            options.set(false, forKey: kSuddenDeath)
            options.set(10, forKey: kWordCount)
            options.set(false, forKey: kFrenchLanguage)
            options.set(0, forKey: kCorrectCount)
            options.set(0, forKey: kIncorrectCount)
            options.set(0, forKey: kMascCorrectCount)
            options.set(0, forKey: kMascIncorrectCount)
            options.set(0, forKey: kFemCorrectCount)
            options.set(0, forKey: kFemIncorrectCount)
            
            print("Default options set!" + String(options.bool(forKey: "OptionsSet")))
        }
    }
    

}

