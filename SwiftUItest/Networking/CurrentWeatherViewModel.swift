//
//  CurrentWeatherViewModel.swift
//  SwiftUItest
//
//  Created by Kaikai Liu on 3/20/20.
//  Copyright © 2020 CMPE277. All rights reserved.
//

//import Foundation
import SwiftUI
import Combine
import MapKit //for CLLocationCoordinate2D

class CurrentWeatherViewModel: ObservableObject, Identifiable {
    // Expose an optional CurrentWeatherRowViewModel as the data source
    @Published var dataSource: CurrentWeatherRowViewModel?
    
    let city: String
    private let weatherFetcher: WeatherFetchable
    private var disposables = Set<AnyCancellable>()
    
    init(city: String, weatherFetcher: WeatherFetchable) {
        self.weatherFetcher = weatherFetcher
        self.city = city
    }
    
    func refresh() {
        weatherFetcher
            .currentWeatherForecast(forCity: city)
            //Transform new values to a CurrentWeatherRowViewModel as they come in the form of a CurrentWeatherForecastResponse format
            .map(CurrentWeatherRowViewModel.init)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure:
                    self.dataSource = nil
                case .finished:
                    break
                }
                }, receiveValue: { [weak self] weather in
                    guard let self = self else { return }
                    self.dataSource = weather
            })
            .store(in: &disposables)
    }
}


struct CurrentWeatherRowViewModel {
  private let item: CurrentWeatherForecastResponse
    
  var name: String {
    return item.name
  }

  var feelsLike: String {
    return String(format: "%.1f", item.main.feelsLike)
  }
  
  var temperature: String {
    return String(format: "%.1f", item.main.temperature)
  }
  
  var maxTemperature: String {
    return String(format: "%.1f", item.main.maxTemperature)
  }
  
  var minTemperature: String {
    return String(format: "%.1f", item.main.minTemperature)
  }
  
  var humidity: String {
    return String(item.main.humidity)
  }
  
  var weatherDescription: String {
    guard let description = item.weather.first?.description else { return "" }
    return description
  }
  
  var conditionName: String {
    guard let weatherId = item.weather.first?.id else { return "questionmark" }
    
    switch weatherId {
      case 200...232:
          return "cloud.bolt"
      case 300...321:
          return "cloud.drizzle"
      case 500...531:
          return "cloud.rain"
      case 600...622:
          return "cloud.snow"
      case 701...781:
          return "cloud.fog"
      case 800:
          return "sun.max"
      case 801...804:
          return "cloud.bolt"
      default:
          return "cloud"
      }
  }
  
  var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D.init(latitude: item.coord.lat, longitude: item.coord.lon)
  }
  
  init(item: CurrentWeatherForecastResponse) {
    self.item = item
  }
}
