//
//  ElementGenerator.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 09.10.2021.
//

import Foundation
import UIKit

func with<T: AnyObject>(_ object: T,  _ completion: (T)->()) -> T{
    completion(object)
    return object
}
