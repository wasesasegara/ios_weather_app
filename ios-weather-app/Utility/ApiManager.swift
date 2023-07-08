//
//  ApiManager.swift
//  ios-weather-app
//
//  Created by Bisma Wasesasegara on 06/07/23.
//

import Foundation

protocol ApiService {
    var url: URL? { get }
    var task: URLSessionTask? { get set }
    var status: FetchStatus { get set }
    func fetch(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    func fetch(queryItems: [URLQueryItem], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    func cancel()
}

class ApiManager: ApiService {
    let url: URL?
    var task: URLSessionTask?
    var status: FetchStatus = .ready
    
    init(url: URL?) {
        self.url = url
    }
    
    func fetch(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        sessionHandler(url: url, completionHandler: completionHandler)
    }
    
    func fetch(queryItems: [URLQueryItem], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard var url = url else { return }
        url.append(queryItems: queryItems)
        sessionHandler(url: url, completionHandler: completionHandler)
    }
    
    private func sessionHandler(url: URL?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard status == .ready, let url = url else { return }
        status = .loading
        let session = URLSession(configuration: .default)
        let request = URLRequest(url: url)
        task = session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            completionHandler(data, response, error)
            self?.status = .ready
        })
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
        status = .ready
    }
    
}

enum FetchStatus {
    case ready, loading
}
