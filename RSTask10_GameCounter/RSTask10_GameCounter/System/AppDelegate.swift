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
    let halpersClass = Halpers()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

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
                halpersClass.getDefaultsAndSetDataClass()
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
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
    
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
        halpersClass.saveDataInUserDefaults(valueForStartBackground: start)
    }
    
    
    
    


}

