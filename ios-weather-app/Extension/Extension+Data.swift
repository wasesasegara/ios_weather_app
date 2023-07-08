//
//  Extension+Data.swift
//  ios-weather-app
//
//  Created by Bisma Wasesasegara on 06/07/23.
//

import Foundation

extension Data {
    
    func parseJSON<T: Decodable>() throws -> T {
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(T.self, from: self)
            return decoded
        } catch {
            print("cannot parse to data type \(String(describing: T.self))")
            throw error
        }
    }
    
}
