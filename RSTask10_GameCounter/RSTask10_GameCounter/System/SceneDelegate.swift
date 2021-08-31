//
//  SceneDelegate.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 25.08.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let defaults = UserDefaults.standard
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        
        if defaults.bool(forKey: "firstLaunch") == false {
            let rootVC = UINavigationController(rootViewController: NewGameVC())
            rootVC.navigationBar.isHidden = true
            window?.rootViewController = rootVC
        } else{
            let playersArray = defaults.decode(for: [Player].self, using: String(describing: Player.self))
            let turnsArray = defaults.decode(for: [Turn].self, using: String(describing: Turn.self))
            let gameTime = defaults.decode(for: GameTime.self, using: String(describing: GameTime.self))
            let timerPlay = defaults.bool(forKey: "timerPlaySaved")
            
            DataClass.sharedInstance().playersArray = playersArray ?? [Player]()
            DataClass.sharedInstance().turnsArray = turnsArray ?? [Turn]()
            DataClass.sharedInstance().gameTime = gameTime ?? GameTime(minute: 0, second: 0 )
            DataClass.sharedInstance().timerPlay = timerPlay
            
            
            let rootVC = GameProcessVC()
            window?.rootViewController = rootVC
        }
        
        
        
        window?.makeKeyAndVisible()
        
    }
    
    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) {
        print("закрыт из диспетчера")
        defaults.setValue(nil, forKey: "startBackground")
        
        defaults.encode(for:DataClass.sharedInstance().playersArray, using: String(describing: Player.self))
        defaults.encode(for:DataClass.sharedInstance().turnsArray, using: String(describing: Turn.self))
        defaults.encode(for:DataClass.sharedInstance().gameTime, using: String(describing: GameTime.self))
        defaults.setValue(DataClass.sharedInstance().timerPlay, forKey: "timerPlaySaved")
        //        defaults.setValue(false, forKey: "firstLaunch")
        //        defaults.setValue(false, forKey: "firstLaunch")
    }
    
    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
        //        DataClass.sharedInstance().gameTime.second=999
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    var timerL = Timer()
    
    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {
        print("появился на экране")
        if DataClass.sharedInstance().timerPlay{
            guard let start = defaults.object(forKey: "startBackground") as? CFAbsoluteTime else {return}
            
            let elapsed = Int(CFAbsoluteTimeGetCurrent() - start)
            let minute =  Int(elapsed / 60)
            let seconds = elapsed % 60
            DataClass.sharedInstance().gameTime.second += seconds
            DataClass.sharedInstance().gameTime.minute += minute
        }
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("ушел в диспетчер задач")
        let start = CFAbsoluteTimeGetCurrent()
        defaults.setValue(start, forKey: "startBackground")
        
        UserDefaults.standard.encode(for:DataClass.sharedInstance().playersArray, using: String(describing: Player.self))
        UserDefaults.standard.encode(for:DataClass.sharedInstance().turnsArray, using: String(describing: Turn.self))
        UserDefaults.standard.encode(for:DataClass.sharedInstance().gameTime, using: String(describing: GameTime.self))
        defaults.setValue(DataClass.sharedInstance().timerPlay, forKey: "timerPlaySaved")
        
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

