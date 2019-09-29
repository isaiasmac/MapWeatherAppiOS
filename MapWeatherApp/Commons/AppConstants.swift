//
//  AppConstants.swift
//  MapWeatherApp
//
//  Created by Isaías López on 9/27/19.
//  Copyright © 2019 Isaías López. All rights reserved.
//

import Foundation

struct AppConstants {
    
    
    static let GOOGLE_APIKEY = "AIzaSyCYYtgjTfgI4kaYxpE5g6gNVmfe2YdE0no"
    static let DEFAULT_ZOOM_LEVEL: Float = 10
    
    static let DARK_SKY_APIKEY = "57d5ae8abaa86bc1a9419156699635e9"
    
    static let URL_DARK_SKY = "https://api.darksky.net/forecast/\(DARK_SKY_APIKEY)/%f,%f?lang=es&exclude=hourly,minutely&units=si"
    
}
