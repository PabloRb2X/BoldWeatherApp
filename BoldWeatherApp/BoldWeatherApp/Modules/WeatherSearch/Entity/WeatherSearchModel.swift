//
//  WeatherSearchModel.swift
//  BoldWeatherApp
//
//  Created by Pablo Ramírez Barrientos on 04/05/22.
//

import Foundation

enum WeatherServiceType {
    case search
    case fetchInfo
}

enum WeatherStateNameType: String, Codable {
    case snow = "Snow"
    case sleet = "Sleet"
    case hail = "Hail"
    case thunderstorm = "Thunderstorm"
    case heavyRain = "Heavy Rain"
    case lightRain = "Light Rain"
    case showers = "Showers"
    case heavyCloud = "Heavy Cloud"
    case lightCloud = "Light Cloud"
    case clear = "Clear"
    
    var imageUrl: String {
        switch self {
        case .snow:
            return getImageUrl(abbreviation: "sn")
        case .sleet:
            return getImageUrl(abbreviation: "sl")
        case .hail:
            return getImageUrl(abbreviation: "h")
        case .thunderstorm:
            return getImageUrl(abbreviation: "t")
        case .heavyRain:
            return getImageUrl(abbreviation: "hr")
        case .lightRain:
            return getImageUrl(abbreviation: "lr")
        case .showers:
            return getImageUrl(abbreviation: "s")
        case .heavyCloud:
            return getImageUrl(abbreviation: "hc")
        case .lightCloud:
            return getImageUrl(abbreviation: "lc")
        case .clear:
            return getImageUrl(abbreviation: "c")
        }
    }
    
    private func getImageUrl(abbreviation: String) -> String {
        return "https://www.metaweather.com/static/img/weather/png/64/\(abbreviation).png"
    }
}

struct WeatherPlace: Codable {
    let title, locationType: String
    let woeid: Int
    let lattLong: String

    enum CodingKeys: String, CodingKey {
        case title
        case locationType = "location_type"
        case woeid
        case lattLong = "latt_long"
    }
}

struct WeatherDescription: Codable {
    let consolidatedWeather: [ConsolidatedWeather]
    let time, sunRise, sunSet, timezoneName: String
    let parent: WeatherParent
    let sources: [WeatherSource]
    let title, locationType: String
    let woeid: Int
    let lattLong, timezone: String

    enum CodingKeys: String, CodingKey {
        case consolidatedWeather = "consolidated_weather"
        case time
        case sunRise = "sun_rise"
        case sunSet = "sun_set"
        case timezoneName = "timezone_name"
        case parent, sources, title
        case locationType = "location_type"
        case woeid
        case lattLong = "latt_long"
        case timezone
    }
}

struct ConsolidatedWeather: Codable {
    let id: Int
    let weatherStateName: WeatherStateNameType
    let weatherStateAbbr, windDirectionCompass, created: String
    let applicableDate: String
    let minTemp, maxTemp, theTemp, windSpeed: Double
    let windDirection, airPressure: Double
    let humidity: Int
    let visibility: Double
    let predictability: Int

    enum CodingKeys: String, CodingKey {
        case id
        case weatherStateName = "weather_state_name"
        case weatherStateAbbr = "weather_state_abbr"
        case windDirectionCompass = "wind_direction_compass"
        case created
        case applicableDate = "applicable_date"
        case minTemp = "min_temp"
        case maxTemp = "max_temp"
        case theTemp = "the_temp"
        case windSpeed = "wind_speed"
        case windDirection = "wind_direction"
        case airPressure = "air_pressure"
        case humidity, visibility, predictability
    }
}

struct WeatherParent: Codable {
    let title, locationType: String
    let woeid: Int
    let lattLong: String

    enum CodingKeys: String, CodingKey {
        case title
        case locationType = "location_type"
        case woeid
        case lattLong = "latt_long"
    }
}

struct WeatherSource: Codable {
    let title, slug: String
    let url: String
    let crawlRate: Int

    enum CodingKeys: String, CodingKey {
        case title, slug, url
        case crawlRate = "crawl_rate"
    }
}
