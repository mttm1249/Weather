//
//  WeatherNetworkService.swift
//  Weather
//
//  Created by mttm on 25.04.2023.
//

import Foundation

class WeatherNetworkService {
    
    private init() {}
    
    static let shared = WeatherNetworkService()
    
    private let apiKey = "95afff5e-0f75-48e8-b816-a7089b10994d"
    
    private func fetchWeatherDataURL(latitude: String, longitude: String, language: String, limit: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.weather.yandex.ru"
        components.path = "/v2/forecast"
        components.queryItems = [
            URLQueryItem(name: "lat", value: latitude),
            URLQueryItem(name: "lon", value: longitude),
            URLQueryItem(name: "lang", value: language),
            URLQueryItem(name: "limit", value: limit)
        ]
        return components.url
    }
    
    func fetchWeatherData(latitude: String, longitude: String, language: String = "ru_RU", limit: String = "7", completionHandler: @escaping (Result<WeatherData, Error>) -> ()) {
        guard let url = fetchWeatherDataURL(latitude: latitude, longitude: longitude, language: language, limit: limit) else {
            print("Invalid URL")
            return
        }
        
        let headers = ["X-Yandex-API-Key": apiKey]
        
        NetworkService.shared.getData(url: url, headers: headers) { result in
            switch result {
            case .success(let data):
                do {
                    let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                    completionHandler(.success(weatherData))
                } catch {
                    print("Failed to decode weather data: \(error)")
                    completionHandler(.failure(error))
                }
            case .failure(let error):
                print("Failed to fetch weather data: \(error)")
                completionHandler(.failure(error))
            }
        }
    }
}
