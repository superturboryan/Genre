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
        
        //Set all state variables
        loadOptions()
       
        checkIfCsvHasBeenLoadedIntoCoreData()
        
        return true
    }
    
    func loadOptions() {
        
         let options = UserDefaults.standard
        
        //Set hints to false by default after checking if the first is set
        if options.bool(forKey: "OptionsSet") == false {
            
            options.set(true, forKey: "OptionsSet")
            
            options.set(false, forKey: "Hints")
            options.set(false, forKey: "Timer")
            options.set(true, forKey: "Progress")
            options.set(10, forKey: "WordCount")
            options.set(false, forKey: "FrenchLanguage")
            options.set(0, forKey: "correctCount")
            options.set(0, forKey: "incorrectCount")
            options.set(false, forKey: "SuddenDeath")
            
            print("Default options set!" + String(options.bool(forKey: "OptionsSet")))
        }
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
    
    

}

