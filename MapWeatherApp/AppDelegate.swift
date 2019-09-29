//
//  AppDelegate.swift
//  MapWeatherApp
//
//  Created by Isaías López on 9/27/19.
//  Copyright © 2019 Isaías López. All rights reserved.
//

import UIKit
import GoogleMaps


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey(AppConstants.GOOGLE_APIKEY)
        
        return true
    }


}

