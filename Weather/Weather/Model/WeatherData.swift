//
//  Weather.swift
//  Weather
//
//  Created by mttm on 25.04.2023.
//

struct WeatherData: Codable {
    let geoObject: GeoObject
    let fact: Fact
    let forecasts: [Forecast]

    enum CodingKeys: String, CodingKey {
        case geoObject = "geo_object"
        case fact, forecasts
    }
}

// MARK: - Fact
struct Fact: Codable {
    let temp, feelsLike: Double
    let condition: Condition

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case condition
    }
}

enum Condition: String, Codable {
    case clear = "clear"
    case cloudy = "cloudy"
    case lightRain = "light-rain"
    case overcast = "overcast"
    case partlyCloudy = "partly-cloudy"
    case rain = "rain"
}

// MARK: - Forecast
struct Forecast: Codable {
    let date: String
    let parts: Parts

    enum CodingKeys: String, CodingKey {
        case date, parts
    }
}

// MARK: - Parts
struct Parts: Codable {
    let day, night: Day

    enum CodingKeys: String, CodingKey {
        case day, night
    }
}

// MARK: - Day
struct Day: Codable {
    let tempAvg: Double?
    let condition: Condition

    enum CodingKeys: String, CodingKey {
        case tempAvg = "temp_avg"
        case condition
    }
}

// MARK: - GeoObject
struct GeoObject: Codable {
    let locality: Country
}

// MARK: - Country
struct Country: Codable {
    let name: String
}
