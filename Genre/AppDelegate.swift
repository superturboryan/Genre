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

        setDefaultOptions()
       
        checkIfCsvHasBeenLoadedIntoCoreData()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
     
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
 
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
   
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext()
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

