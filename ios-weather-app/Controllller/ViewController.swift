//
//  ViewController.swift
//  ios-weather-app
//
//  Created by Bisma Wasesasegara on 03/07/23.
//

import CoreLocation
import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var weatherMainLabel: UILabel!
    
    private lazy var weatherManager: WeatherService = WeatherManager(delegate: self)
    private let locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lastCityName = UserDefaults.standard.string(forKey: "lastCityName") ?? "Jakarta"
        weatherManager.fetchWeather(cityName: lastCityName)
        
        locationManager.delegate = self
        
        searchTextField.delegate = self
        searchTextField.autocorrectionType = .no
        searchTextField.placeholder = "Type area name"
    }
    
    @IBAction func didTapCurrentLocationButton(_ sender: Any) {
        checkLocation()
    }
    
    @IBAction func didTapSearchButton(_ sender: Any) {
        searchTextField.endEditing(true)
    }
    
    private func checkLocation() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something here"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = textField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
    
}

// MARK: - WeatherServiceDelegate

extension ViewController: WeatherServiceDelegate {
    
    func weatherService(_ service: WeatherService, didUpdateWithObject weather: WeatherModel) {
        UserDefaults.standard.set(weather.cityName, forKey: "lastCityName")
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.weatherIconImageView.image = weather.icon
            self.temperatureLabel.text = weather.temperature
            self.cityLabel.text = weather.cityName
            self.weatherMainLabel.text = weather.weatherInfo
        }
    }
    
    func weatherService(_ service: WeatherService, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}

// MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(lat: lat, lon: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
