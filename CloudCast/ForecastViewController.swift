//
//  ViewController.swift
//  CloudCast
//
//  Created by Mari Batilando on 3/29/23.
//

import UIKit

struct Location {
  let name: String
  let latitude: Double
  let longitude: Double
}

class ForecastViewController: UIViewController {
  
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var windspeedLabel: UILabel!
  @IBOutlet weak var windDirectionLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var forecastImageView: UIImageView!

    private var selectedLocationIndex = 0
    private var locations = [Location]()
    
  override func viewDidLoad() {
    super.viewDidLoad()
    addGradient()
    let sanJose = Location(name: "San Jose", latitude: 37.335480, longitude: -121.893028)
    let manila = Location(name: "Manila", latitude: 12.8797, longitude: 121.7740)
    let italy = Location(name: "Italy", latitude: 41.8719, longitude: 12.5674)
    locations = [sanJose, manila, italy]
      
    changeLocation(withLocationIndex: 0)
  }
    
    private func changeLocation(withLocationIndex locationIndex: Int) {
        guard locationIndex < locations.count else { return }
        let location = locations[locationIndex]
        locationLabel.text = location.name
        WeatherForecastService.fetchForecast(latitude: location.latitude, longitude: location.longitude) { forecast in
                self.configure(with: forecast)
            }
    }
    private func configure(with forecast: CurrentWeatherForecast) {
        forecastImageView.image = forecast.weatherCode.image
        descriptionLabel.text = forecast.weatherCode.description
        temperatureLabel.text = "\(forecast.temperature)"
        windspeedLabel.text = "\(forecast.windSpeed) mph"
        windDirectionLabel.text = "\(forecast.windDirection)°"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        dateLabel.text = dateFormatter.string(from: Date())
    }
  
  private func addGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                            UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    view.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  @IBAction func didTapBackButton(_ sender: UIButton) {
      selectedLocationIndex = max(0, selectedLocationIndex - 1) // make sure selectedLocationIndex is always >= 0
      changeLocation(withLocationIndex: selectedLocationIndex)
  }
  
  @IBAction func didTapForwardButton(_ sender: UIButton) {
      selectedLocationIndex = min(locations.count - 1, selectedLocationIndex + 1) // make sure selectedLocationIndex is always < locations.count
      changeLocation(withLocationIndex: selectedLocationIndex)
  }
}

