//
//  WeatherDaily.swift
//  MapWeatherApp
//
//  Created by Isaías López on 9/28/19.
//  Copyright © 2019 Isaías López. All rights reserved.
//

import Foundation

struct WeatherDaily: Decodable {
    let time: Double
    let summary, icon: String
    let sunriseTime, sunsetTime: Double
    let moonPhase, precipIntensity, precipIntensityMax: Double
    let precipIntensityMaxTime: Float
    let precipProbability: Float
    let precipType: String
    let temperatureHigh: Float
    let temperatureHighTime: Float
    let temperatureLow: Float
    let temperatureLowTime: Float
    let apparentTemperatureHigh: Float
    let apparentTemperatureHighTime: Float
    let apparentTemperatureLow: Double
    let apparentTemperatureLowTime: Float
    let dewPoint, humidity, pressure, windSpeed: Float
    let windGust: Float
    let windGustTime, windBearing: Float
    let cloudCover: Float
    let uvIndex: Int
    let uvIndexTime: Float
    let visibility, ozone, temperatureMin: Double
    let temperatureMinTime: Float
    let temperatureMax: Float
    let temperatureMaxTime: Float
    let apparentTemperatureMin: Float
    let apparentTemperatureMinTime: Float
    let apparentTemperatureMax: Float
    let apparentTemperatureMaxTime: Float
}
