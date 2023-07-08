//
//  Endpoint.swift
//  ios-weather-app
//
//  Created by Bisma Wasesasegara on 06/07/23.
//

import Foundation

/// Use your own API key from openweathermap.org
private let apiKey = ""

struct Endpoint {
    
    private static let baseComponent: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        return components
    }()
    
    static func url(path: String) -> URL? {
        var components = baseComponent
        components.path = path
        var url = components.url
        url?.append(queryItems: [URLQueryItem(name: "appid", value: apiKey)])
        return url
    }
    
}

struct UrlPath {
    static let weather = "/data/2.5/weather"
}
