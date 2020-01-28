//
//  Dictionary.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 20/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

extension Dictionary {
    func dictionaryToObject<T: Decodable>() -> T? {
        //(data: [[String: Any]]) -> T? {
    //func dictionaryToObject() -> Meeting? {
        do {
            let json = try JSONSerialization.data(withJSONObject: self, options: [])
            let decoder = JSONDecoder()
            let object = try decoder.decode(T.self, from: json)
            return object
        } catch {
            print(error)
            return nil
        }
    }
    
    func decoded<T: Decodable>() -> T? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            let object = try JSONDecoder().decode(T.self, from: jsonData)
            return object
        } catch {
            print(error)
            return nil
        }
    }
}
