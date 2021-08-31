//
//  AppDelegate.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 25.08.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let defaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        defaults.setValue(nil, forKey: "startBackground")
        
        window = UIWindow()
        
        if #available(iOS 13, *){
            return true
        }else {
            if defaults.bool(forKey: "firstLaunch") == false {
                let rootVC = UINavigationController(rootViewController: NewGameVC())
                rootVC.navigationBar.isHidden = true
                window?.rootViewController = rootVC
            } else{
                let playersArray = defaults.decode(for: [Player].self, using: String(describing: Player.self))
                let turnsArray = defaults.decode(for: [Turn].self, using: String(describing: Turn.self))
                let gameTime = defaults.decode(for: GameTime.self, using: String(describing: GameTime.self))
//                let timerPlay = defaults.bool(forKey: "timerPlaySaved")
                
                DataClass.sharedInstance().playersArray = playersArray ?? [Player]()
                DataClass.sharedInstance().turnsArray = turnsArray ?? [Turn]()
                DataClass.sharedInstance().gameTime = gameTime ?? GameTime(minute: 0, second: 0 )
                DataClass.sharedInstance().timerPlay = true
                
                
                let rootVC = GameProcessVC()
                window?.rootViewController = rootVC
            }

            window?.makeKeyAndVisible()
            
            return true
        }
        
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("появился на экране")
        guard let start = defaults.object(forKey: "startBackground") as? CFAbsoluteTime else {return}
        
        let elapsed = Int(CFAbsoluteTimeGetCurrent() - start)
        let minute =  Int(elapsed / 60)
        let seconds = elapsed % 60
        DataClass.sharedInstance().gameTime.second += seconds
        DataClass.sharedInstance().gameTime.minute += minute
    }
    

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("ушел в диспетчер задач")
        let start = CFAbsoluteTimeGetCurrent()
        defaults.setValue(start, forKey: "startBackground")

        UserDefaults.standard.encode(for:DataClass.sharedInstance().playersArray, using: String(describing: Player.self))
        UserDefaults.standard.encode(for:DataClass.sharedInstance().turnsArray, using: String(describing: Turn.self))
        UserDefaults.standard.encode(for:DataClass.sharedInstance().gameTime, using: String(describing: GameTime.self))
        defaults.setValue(DataClass.sharedInstance().timerPlay, forKey: "timerPlaySaved")
    }
    
    
    
    


}

