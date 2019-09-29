//
//  WeatherService.swift
//  MapWeatherApp
//
//  Created by Isaías López on 9/27/19.
//  Copyright © 2019 Isaías López. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherService {
    
    static func getInfo(lat: Double = 0.0, lng: Double = 0.0, completion: @escaping (Bool, Weather?) -> ()) {
        let url = String(format: AppConstants.URL_DARK_SKY, arguments: [lat, lng])
        print("\(#function)  URL: \(url)")
        
        Alamofire.request(url).responseJSON { response in
            switch response.result {
                case .success:
                    if let data = response.data {
                        let json = JSON(data)
                        let weather = Weather.parseFromJSON(weatherJSON: json)
                        completion(true, weather)
                    }
                case .failure(let error):
                    let dataDict: [String: String] = ["message": error.localizedDescription]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppKeys.WEATHER_SERVICE_FAILED),
                                                    object: nil,
                                                    userInfo: dataDict)
                    completion(false, nil)
            }
        }
        
    }
    
    
}
