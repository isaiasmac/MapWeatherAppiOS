//
//  Weather.swift
//  MapWeatherApp
//
//  Created by Isaías López on 9/27/19.
//  Copyright © 2019 Isaías López. All rights reserved.
//

import Foundation
import SwiftyJSON

// clear-day, clear-night, rain, snow, sleet, wind, fog, cloudy, partly-cloudy-day, or partly-cloudy-night
enum WeatherIcon: String {
    case ClearDay
    case ClearNight
    case Rain
    case Snow
    case Sleet
    case Wind
    case Fog
    case Cloudy
    case PartlyCloudyDay
    case PartlyCloudyNight
    
    func icon() -> String {
        return self.rawValue.lowercased()
    }
}

enum WeatherPrecipType: String {
    case rain
    case snow
    case sleet
    
    func type() -> String {
        return self.rawValue
    }
}

struct Weather {
    var summary: String = ""
    var icon: String = ""
    var humidity: NSNumber = 0.0
    var precipProbability: NSNumber = 0.0
    var temperature: NSNumber = 0.0
    var precipType: String? = ""
    //var daily: [WeatherDaily] = []
    
    func getTemperature() -> Int {
        return Int(self.temperature.floatValue.rounded())
    }
    
    // The relative humidity, between 0 and 1, inclusive.
    // Hay entregar el valor en porcentaje. 1 = 100%
    func getHumidity() -> Int {
        return Int(self.humidity.floatValue * 100.0)
    }
    
    func getPrecipProbability() -> Int {
        return Int(self.precipProbability.floatValue * 100.0)
    }
    
    static func getPrecipType(precipType: String?) -> String {
        if let _precipType = precipType {
            switch _precipType {
            case WeatherPrecipType.rain.rawValue:
                return "Lluvia"
            case WeatherPrecipType.snow.rawValue:
                return "Nieve"
            case WeatherPrecipType.sleet.rawValue:
                return "Agua Nieve"
            default:
                return ""
            }
        }
        
        return ""
    }
    
    static func parseFromJSON(weatherJSON: JSON) -> Weather? {
        guard let currently = weatherJSON[AppKeys.CURRENTLY].dictionaryObject else {
            return nil
        }
        
        var weather = Weather()
        weather.summary = currently[AppKeys.SUMMARY] as! String
        weather.icon = currently[AppKeys.ICON] as! String
        weather.humidity = currently[AppKeys.HUMIDITY] as! NSNumber
        weather.precipProbability = currently[AppKeys.PRECIP_PROBABILITY] as! NSNumber
        weather.temperature = currently[AppKeys.TEMPERATURE] as! NSNumber
        let precipType = currently[AppKeys.PRECIP_TYPE] as? String
        weather.precipType = self.getPrecipType(precipType: precipType)
        
        return weather
    }
}


