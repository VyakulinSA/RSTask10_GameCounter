//
//  UserDefaultsManager.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 26.08.2021.
//

import Foundation

class UserDefaultsManager{
    private let dataShared = DataClass.sharedInstance()
    let defaults = UserDefaults.standard
    
    func getDefaultsAndSetDataClass() {
        //get saved objects
        let playersArray = defaults.decode(for: [Player].self, using: String(describing: Player.self))
        let turnsArray = defaults.decode(for: [Turn].self, using: String(describing: Turn.self))
        let gameTime = defaults.decode(for: GameTime.self, using: String(describing: GameTime.self))
        //set DataClass for next views
        dataShared.playersArray = playersArray ?? [Player]()
        dataShared.turnsArray = turnsArray ?? [Turn]()
        dataShared.gameTime = gameTime ?? GameTime(minute: 0, second: 0 )
        dataShared.timerPlay = true
    }
    
    func saveDataInUserDefaults(valueForStartBackground: CFAbsoluteTime?) {
        defaults.setValue(valueForStartBackground, forKey: "startBackground")
        
        defaults.encode(for:dataShared.playersArray, using: String(describing: Player.self))
        defaults.encode(for:dataShared.turnsArray, using: String(describing: Turn.self))
        defaults.encode(for:dataShared.gameTime, using: String(describing: GameTime.self))
        defaults.setValue(dataShared.timerPlay, forKey: "timerPlaySaved")
    }
}
