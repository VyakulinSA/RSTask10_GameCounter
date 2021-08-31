//
//  Halpers.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 26.08.2021.
//

import Foundation

enum CustomFonts: String {
    case nunitoExtraBold = "Nunito-ExtraBold"
    case nunitoSemiBold = "Nunito-SemiBold"
    case nunitoBold = "Nunito-Bold"
}

class Halpers{
    
    let defaults = UserDefaults.standard
    
    func getDefaultsAndSetDataClass(){
        //get saved objects
        let playersArray = defaults.decode(for: [Player].self, using: String(describing: Player.self))
        let turnsArray = defaults.decode(for: [Turn].self, using: String(describing: Turn.self))
        let gameTime = defaults.decode(for: GameTime.self, using: String(describing: GameTime.self))
        //set DataClass for next views
        DataClass.sharedInstance().playersArray = playersArray ?? [Player]()
        DataClass.sharedInstance().turnsArray = turnsArray ?? [Turn]()
        DataClass.sharedInstance().gameTime = gameTime ?? GameTime(minute: 0, second: 0 )
        DataClass.sharedInstance().timerPlay = true
    }
    
    func saveDataInUserDefaults(valueForStartBackground: Any?) {
        defaults.setValue(valueForStartBackground, forKey: "startBackground")
        
        defaults.encode(for:DataClass.sharedInstance().playersArray, using: String(describing: Player.self))
        defaults.encode(for:DataClass.sharedInstance().turnsArray, using: String(describing: Turn.self))
        defaults.encode(for:DataClass.sharedInstance().gameTime, using: String(describing: GameTime.self))
        defaults.setValue(DataClass.sharedInstance().timerPlay, forKey: "timerPlaySaved")
    }
}
