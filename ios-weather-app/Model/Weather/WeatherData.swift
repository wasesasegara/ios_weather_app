//
//  WeatherData.swift
//  ios-weather-app
//
//  Created by Bisma Wasesasegara on 06/07/23.
//

import Foundation

struct WeatherData: Decodable {
    var id: Int
    var name: String
    var main: Main
    var weather: [Weather]
}

struct Main: Decodable {
    var temp: Double
    var pressure: Double
    var humidity: Double
}

struct Weather: Decodable {
    var id: Int
    var main: String
    var icon: String
}
