//
//  DataClass.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 29.08.2021.
//

import Foundation

class DataClass{
    static var shared: DataClass = {
        let instance = DataClass()
        return instance
    }()
    
    private init() {}
    
    var playersArray = [Player(name: "aaa", score: 0, select: true),
                        Player(name: "bbb", score: 0, select: false),
                        Player(name: "ccc", score: 0, select: false),
                        Player(name: "ddd", score: 0, select: false)]
    var turnsArray = [Turn]()
    
    class func sharedInstance() -> DataClass {
        return DataClass.shared
    }
    
}


struct Player {
    let name: String
    var score: Int
    var select: Bool
    let id = UUID()
}

struct Turn {
    let player: Player
    let addScore: String
    let playersIndex: IndexPath
}
