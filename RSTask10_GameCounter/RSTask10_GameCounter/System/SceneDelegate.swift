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
    let halpersClass = Halpers()
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        if defaults.bool(forKey: "firstLaunch") == false {
            let rootVC = UINavigationController(rootViewController: NewGameVC())
            rootVC.navigationBar.isHidden = true
            window?.rootViewController = rootVC
        } else{
            halpersClass.getDefaultsAndSetDataClass()
            let rootVC = GameProcessVC()
            window?.rootViewController = rootVC
        }

        window?.makeKeyAndVisible()
    }
    
    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) {
        halpersClass.saveDataInUserDefaults(valueForStartBackground: nil)
    }
    
    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {}
    
    var timerL = Timer()
    
    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene) {}
    
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
    }
    
    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("ушел в диспетчер задач")
        let start = CFAbsoluteTimeGetCurrent()
        halpersClass.saveDataInUserDefaults(valueForStartBackground: start)
    }
    
    
}


