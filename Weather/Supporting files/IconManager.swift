//
//  IconManager.swift
//  Weather
//
//  Created by mttm on 25.04.2023.
//

import Foundation

import UIKit

class IconManager {
    static func getIcon(_ condition: Condition) -> UIImage {
        var iconImage: UIImage?
        switch condition.rawValue {
        case "clear":
            iconImage = UIImage(systemName: "sun.max")
        case "partly-cloudy":
            iconImage = UIImage(systemName: "cloud.sun")
        case "cloudy":
            iconImage = UIImage(systemName: "cloud.sun")
        case "overcast":
            iconImage = UIImage(systemName: "cloud.fill")
        case "drizzle":
            iconImage = UIImage(systemName: "cloud.drizzle")
        case "rain" , "moderate-rain", "light-rain":
            iconImage = UIImage(systemName: "cloud.rain")
        case "heavy-rain":
            iconImage = UIImage(systemName: "cloud.heavyrain")
        case "showers":
            iconImage = UIImage(systemName: "cloud.heavyrain.fill")
        case "thunderstorm", "thunderstorm-with-rain":
            iconImage = UIImage(systemName: "cloud.bolt.rain")
        default:
            break
        }
        return iconImage?.withRenderingMode(.alwaysOriginal).withTintColor(.black) ?? UIImage()
    }
}

//Код расшифровки погодного описания. Возможные значения:
//clear — ясно.
//partly-cloudy — малооблачно.
//cloudy — облачно с прояснениями.
//overcast — пасмурно.
//drizzle — морось.
//light-rain — небольшой дождь.
//rain — дождь.
//moderate-rain — умеренно сильный дождь.
//heavy-rain — сильный дождь.
//continuous-heavy-rain — длительный сильный дождь.
//showers — ливень.
//wet-snow — дождь со снегом.
//light-snow — небольшой снег.
//snow — снег.
//snow-showers — снегопад.
//hail — град.
//thunderstorm — гроза.
//thunderstorm-with-rain — дождь с грозой.
//thunderstorm-with-hail — гроза с градом.
