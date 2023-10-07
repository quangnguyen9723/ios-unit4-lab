//
//  WeatherForecastService.swift
//  CloudCast
//
//  Created by Quang Nguyen on 10/7/23.
//

import Foundation

class WeatherForecastService {
  static func fetchForecast(latitude: Double,
                            longitude: Double,
                            completion: ((CurrentWeatherForecast) -> Void)? = nil) {
    let parameters = "latitude=\(latitude)&longitude=\(longitude)&current_weather=true&temperature_unit=fahrenheit&timezone=auto&windspeed_unit=mph"
    let url = URL(string: "https://api.open-meteo.com/v1/forecast?\(parameters)")!
    // create a data task and pass in the URL
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      // this closure is fired when the response is received
      guard error == nil else {
        assertionFailure("Error: \(error!.localizedDescription)")
        return
      }
      guard let httpResponse = response as? HTTPURLResponse else {
        assertionFailure("Invalid response")
        return
      }
      guard let data = data, httpResponse.statusCode == 200 else {
        assertionFailure("Invalid response status code: \(httpResponse.statusCode)")
        return
      }
      // at this point, `data` contains the data received from the response
        let forecast = parse(data: data)
          // this response will be used to change the UI, so it must happen on the main thread
          DispatchQueue.main.async {
            completion?(forecast) // call the completion closure and pass in the forecast data model
          }
        let decoder = JSONDecoder()
      let response = try! decoder.decode(WeatherAPIResponse.self, from: data)
      DispatchQueue.main.async {
        completion?(response.currentWeather)
      }
    }
    task.resume() // resume the task and fire the request
  }
    
    private static func parse(data: Data) -> CurrentWeatherForecast {
        // transform the data we received into a dictionary [String: Any]
        let jsonDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let currentWeather = jsonDictionary["current_weather"] as! [String: Any]
        // wind speed
        let windSpeed = currentWeather["windspeed"] as! Double
        // wind direction
        let windDirection = currentWeather["winddirection"] as! Double
        // temperature
        let temperature = currentWeather["temperature"] as! Double
        // weather code
        let weatherCodeRaw = currentWeather["weathercode"] as! Int
        return CurrentWeatherForecast(windSpeed: windSpeed,
                                      windDirection: windDirection,
                                      temperature: temperature,
                                      weatherCodeRaw: weatherCodeRaw)
      }

}
