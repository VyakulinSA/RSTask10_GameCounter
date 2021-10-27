//
//  DataClass.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 29.08.2021.
//

import Foundation

class DataClass{
    static var shared: DataClass = .init()
    
    private init() {}
    
    var playersArray = [Player]()
    var turnsArray = [Turn]()
    
    var gameTime = GameTime(minute: 0, second: 0)
    
    class func sharedInstance() -> DataClass {
        return DataClass.shared
    }
    
    var timerPlay = true
    
}

struct Player: Codable {
    let name: String
    var score: Int
    var select: Bool
    var playersIndex: IndexPath = [0,0]
}

struct Turn: Codable {
    let player: Player
    let addScore: String
    let playersIndex: IndexPath
}

struct GameTime: Codable {
    var minute: Int
    var second: Int
}
