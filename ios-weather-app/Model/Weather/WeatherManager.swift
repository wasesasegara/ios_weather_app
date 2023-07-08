//
//  WeatherManager.swift
//  ios-weather-app
//
//  Created by Bisma Wasesasegara on 06/07/23.
//

import Foundation
import UIKit

protocol WeatherServiceDelegate: AnyObject {
    func weatherService(_ service: WeatherService, didUpdateWithObject weather: WeatherModel)
    func weatherService(_ service: WeatherService, didFailWithError error: Error)
}

protocol WeatherService {
    var delegate: WeatherServiceDelegate? { get set }
    func fetchWeather(cityName: String)
    func fetchWeather(lat: Double, lon: Double)
    func fetchIcon(url: URL?)
}

class WeatherManager: WeatherService {
    
    private var apiManagerWeather: ApiService = ApiManager(url: Endpoint.url(path: UrlPath.weather))
    private var apiManagerIcon: ApiService?
    
    weak var delegate: WeatherServiceDelegate?
    var weatherModel: WeatherModel = WeatherModel()
    
    init(delegate: WeatherServiceDelegate?) {
        self.delegate = delegate
    }
    
    func fetchWeather(cityName: String) {
        fetchWeather(queryItems: [
            URLQueryItem(name: "q", value: cityName),
            URLQueryItem(name: "units", value: "metric")
        ])
    }
    
    func fetchWeather(lat: Double, lon: Double) {
        fetchWeather(queryItems: [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon)),
            URLQueryItem(name: "units", value: "metric")
        ])
    }
    
    private func fetchWeather(queryItems: [URLQueryItem]) {
        apiManagerWeather.cancel()
        
        // Make weather loading.
        delegate?.weatherService(self, didUpdateWithObject: WeatherModel())
        
        apiManagerWeather.fetch(
            queryItems: queryItems
        ) { [weak self] data, _, error in
            guard let self = self else { return }
            
            if let error = error {
                self.delegate?.weatherService(self, didUpdateWithObject: self.weatherModel)
                self.delegate?.weatherService(self, didFailWithError: error)
                return
            }
            
            if let data = data {
                do {
                    let weather: WeatherData = try data.parseJSON()
                    self.weatherModel = WeatherModel(weather: weather)
                    self.delegate?.weatherService(self, didUpdateWithObject: self.weatherModel)
                    self.fetchIcon(url: URL(string: self.weatherModel.iconUrl))
                } catch {
                    self.delegate?.weatherService(self, didFailWithError: error)
                }
            }
        }
    }
    
    func fetchIcon(url: URL?) {
        apiManagerIcon = ApiManager(url: url)
        apiManagerIcon?.fetch { [weak self] data, _, error in
            guard let self = self else { return }

            if let error = error {
                self.weatherModel.icon = UIImage(systemName: "scribble")
                self.delegate?.weatherService(self, didUpdateWithObject: self.weatherModel)
                self.delegate?.weatherService(self, didFailWithError: error)
                return
            }

            if let data = data {
                self.weatherModel.icon = UIImage(data: data)
                self.delegate?.weatherService(self, didUpdateWithObject: self.weatherModel)
            }
        }
    }
    
}
