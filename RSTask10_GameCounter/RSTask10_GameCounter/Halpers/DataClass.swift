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
    
    var playersArray = [Player]()
    
    class func sharedInstance() -> DataClass {
        return DataClass.shared
    }
    
}


struct Player {
    let name: String
    let score: Int
}
