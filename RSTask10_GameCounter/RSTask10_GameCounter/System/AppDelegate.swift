//
//  AppDelegate.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 25.08.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var dataShared: DataClass!
    private var defaults: UserDefaults!
    private var halpersClass: UserDefaultsManager!
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

            halpersClass = UserDefaultsManager()
            defaults = UserDefaults.standard
            dataShared = DataClass.sharedInstance()
            defaults.setValue(nil, forKey: "startBackground")
            
            window = UIWindow()
            
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
            
            if dataShared.timerPlay{
                guard let start = defaults.object(forKey: "startBackground") as? CFAbsoluteTime else {return true}
                
                let elapsed = Int(CFAbsoluteTimeGetCurrent() - start)
                let minute =  Int(elapsed / 60)
                let seconds = elapsed % 60
                dataShared.gameTime.second += seconds
                dataShared.gameTime.minute += minute
                
                defaults.setValue(nil, forKey: "startBackground")
            }
            
            return true
        
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("появился на экране")
        guard let start = defaults.object(forKey: "startBackground") as? CFAbsoluteTime else {return}
        
        let elapsed = Int(CFAbsoluteTimeGetCurrent() - start)
        let minute =  Int(elapsed / 60)
        let seconds = elapsed % 60
        dataShared.gameTime.second += seconds
        dataShared.gameTime.minute += minute
    }
    

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("ушел в диспетчер задач")
        let start = CFAbsoluteTimeGetCurrent()
        halpersClass.saveDataInUserDefaults(valueForStartBackground: start)
    }
    
    
    
    


}

