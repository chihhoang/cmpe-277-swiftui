//
//  DailyWeatherRowViewModel.swift
//  SwiftUItest
//
//  Created by Kaikai Liu on 3/19/20.
//  Copyright © 2020 CMPE277. All rights reserved.
//

import Foundation

import SwiftUI

let dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd"
    return formatter
}()

let monthFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM"
    return formatter
}()

struct DailyWeatherRowViewModel: Identifiable {
    
    private let item: WeeklyForecastResponse.Item
    
    var id: String {
        return day + temperature + title
    }
    
    var day: String {
        return dayFormatter.string(from: item.date)
    }
    
    var month: String {
        return monthFormatter.string(from: item.date)
    }
    
    var temperature: String {
        return String(format: "%.1f", item.main.temp)
    }
    
    var title: String {
        guard let title = item.weather.first?.main.rawValue else { return "" }
        return title
    }
    
    var fullDescription: String {
        guard let description = item.weather.first?.weatherDescription else { return "" }
        return description
    }
  
    var windSpeed: String {
        return String(format: "%.2f", item.wind.speed)
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
    
    init(item: WeeklyForecastResponse.Item) {
        self.item = item
    }
}

// Used to hash on just the day in order to produce a single view model for each
// day when there are multiple items per each day.
extension DailyWeatherRowViewModel: Hashable {
    static func == (lhs: DailyWeatherRowViewModel, rhs: DailyWeatherRowViewModel) -> Bool {
        return lhs.day == rhs.day
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.day)
    }
}


