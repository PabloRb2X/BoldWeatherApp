//
//  ServiceDefinitions.swift
//  BoldWeatherApp
//
//  Created by Pablo Ramírez Barrientos on 04/05/22.
//

import Foundation

enum ServiceDefinitions {
    static func weatherSearch(text: String) -> String {
        return String(format: "%@%@", "https://www.metaweather.com/api/location/search/?query=", text)
    }
    
    static func weatherDescription(woeid: Int) -> String {
        return String(format: "%@%@", "https://www.metaweather.com/api/location/", "\(woeid)")
    }
}
