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
        defaults.setValue(nil, forKey: "startBackground")
        let rootVC: UIViewController?
        
        
        let firstLaunch = defaults.bool(forKey: "firstLaunch")
        if firstLaunch == false {
            defaults.setValue(true, forKey: "firstLaunch")
            rootVC = NewGameVC()
        } else{
            rootVC = GameProcessVC()
        }
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        
    }

    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) {
        print("sceneDidDisconnect")
        defaults.setValue(nil, forKey: "startBackground")
        defaults.setValue(DataClass.sharedInstance().gameTime.second, forKey: "timerSeconds")
        defaults.setValue(DataClass.sharedInstance().gameTime.minute, forKey: "timerMinutes")
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
//        DataClass.sharedInstance().gameTime.second=999
        print("sceneDidBecomeActive")
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    var timerL = Timer()
    
    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene) {
        //сохранить данные
        print("sceneWillResignActive")
        
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {
        print("sceneWillEnterForeground")
        guard let start = defaults.object(forKey: "startBackground") as? CFAbsoluteTime else {return}
//        let lastSeconds = defaults.integer(forKey: "timerSeconds")
//        let lastMinute = defaults.integer(forKey: "timerMinutes")
        
        let elapsed = Int(CFAbsoluteTimeGetCurrent() - start)
        let minute =  Int(elapsed / 60)
        let seconds = elapsed % 60
        DataClass.sharedInstance().gameTime.second += seconds
        DataClass.sharedInstance().gameTime.minute += minute
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("sceneDidEnterBackground")
        let start = CFAbsoluteTimeGetCurrent()
//        defaults.setValue(DataClass.sharedInstance().gameTime.second, forKey: "timerSeconds")
//        defaults.setValue(DataClass.sharedInstance().gameTime.minute, forKey: "timerMinutes")
        defaults.setValue(start, forKey: "startBackground")
//        defaults.setValue(Date, forKey: "timerMinutes")
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

