//
//  WeatherModel.swift
//  ios-weather-app
//
//  Created by Bisma Wasesasegara on 08/07/23.
//

import Foundation
import UIKit

class WeatherModel {
    var icon: UIImage? = nil
    var iconUrl: String = ""
    var cityName: String = ""
    var temperature: String = ""
    var weatherInfo: String = ""
    
    convenience init(weather: WeatherData) {
        self.init()
        cityName = weather.name
        temperature = String(format: "%.1f", weather.main.temp) + "° C"
        iconUrl = "https://openweathermap.org/img/wn/\(weather.weather.first?.icon ?? "")@2x.png"
        weatherInfo = weather.weather.first?.main ?? ""
    }
    
}
