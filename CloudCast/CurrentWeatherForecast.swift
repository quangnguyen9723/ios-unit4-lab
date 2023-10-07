//
//  WeatherForecast.swift
//  CloudCast
//
//  Created by Mari Batilando on 3/31/23.
//

import Foundation
import UIKit

// Based on https://open-meteo.com/en/docs
enum WeatherCode: Int {
  case clearSky = 0
  case mainlyClear = 1
  case partlyCloudy = 2
  case overcast = 3
  case fog = 45
  case rimeFog = 48
  case drizzleLight = 51
  case drizzleModerate = 53
  case drizzleDense = 55
  case freezingDrizzleLight = 56
  case freezingDrizzleDense = 57
  case rainSlight = 61
  case rainModerate = 63
  case rainHeavy = 65
  case freezingRainLight = 66
  case freezingRainHeavy = 67
  case snowFallSlight = 71
  case snowFallModerate = 73
  case snowFallHeavy = 75
  case snowGrains = 77
  case rainShowersSlight = 80
  case rainShowersModerate = 81
  case rainShowersViolent = 82
  case snowShowersSlight = 85
  case snowShowersHeavy = 86
  case thunderstormSlight = 95
  case thunderstormSlightHail = 96
  case thunderstormHeavyHail = 99
  
  var description: String {
    switch self {
    case .clearSky:
      return "Clear skies"
    case .mainlyClear:
      return "Mainly clear"
    case .partlyCloudy, .overcast:
      return "Cloudy or overcast"
    case .fog, .rimeFog:
      return "Foggy"
    case .drizzleLight, .drizzleModerate, .drizzleDense:
      return "Drizzle"
    case .freezingDrizzleLight, .freezingDrizzleDense, .freezingRainLight, .freezingRainHeavy:
      return "Freezing rain"
    case .rainSlight, .rainModerate, .rainHeavy, .rainShowersSlight, .rainShowersModerate, .rainShowersViolent:
      return "Rainy"
    case .snowFallSlight, .snowFallModerate, .snowFallHeavy, .snowGrains, .snowShowersSlight, .snowShowersHeavy:
      return "Snowy"
    case .thunderstormSlight, .thunderstormSlightHail, .thunderstormHeavyHail:
      return "Thunderstorms"
    }
  }
  
  var image: UIImage? {
    switch self {
    case .clearSky, .mainlyClear:
      return UIImage(named: "sun")
    case .partlyCloudy, .overcast:
      return UIImage(named: "cloud-sun")
    case .fog, .rimeFog:
      return UIImage(named: "fog")
    case .drizzleLight, .drizzleModerate, .drizzleDense:
      return UIImage(named: "drizzle")
    case .freezingDrizzleLight, .freezingDrizzleDense, .freezingRainLight, .freezingRainHeavy:
      return UIImage(named: "cloud-drizzle")
    case .rainSlight, .rainModerate, .rainHeavy, .rainShowersSlight, .rainShowersModerate, .rainShowersViolent:
      return UIImage(named: "cloud-drizzle")
    case .snowFallSlight, .snowFallModerate, .snowFallHeavy, .snowGrains, .snowShowersSlight, .snowShowersHeavy:
      return UIImage(named: "snow")
    case .thunderstormSlight, .thunderstormSlightHail, .thunderstormHeavyHail:
      return UIImage(named: "lightning")
    }
  }
}

struct WeatherAPIResponse: Decodable {
  let currentWeather: CurrentWeatherForecast

  private enum CodingKeys: String, CodingKey {
    case currentWeather = "current_weather"
  }
}

struct CurrentWeatherForecast: Decodable {
  let windSpeed: Double
  let windDirection: Double
  let temperature: Double
  let weatherCodeRaw: Int
  var weatherCode: WeatherCode {
    return WeatherCode(rawValue: weatherCodeRaw) ?? .clearSky
  }
    
    private enum CodingKeys: String, CodingKey {
        case windSpeed = "windspeed"
        case windDirection = "winddirection"
        case temperature = "temperature"
        case weatherCodeRaw = "weathercode"
      }
}
