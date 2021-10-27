//
//  UserDefaults+extension.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 30.08.2021.
//

import Foundation

extension UserDefaults {
    func decode<T : Codable>(for type : T.Type, using key : String) -> T? {
        guard let data = object(forKey: key) as? Data else {return nil}
        let decodedObject = try? PropertyListDecoder().decode(type, from: data)
        return decodedObject
    }

    func encode<T : Codable>(for type : T, using key : String) {
        let encodedData = try? PropertyListEncoder().encode(type)
        set(encodedData, forKey: key)
        synchronize()
    }
}
