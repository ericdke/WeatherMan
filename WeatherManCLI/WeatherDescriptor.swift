//
//  WeatherDescriptor.swift
//  WeatherManCLI
//
//  Created by ERIC DEJONCKHEERE on 11/06/2016.
//  Copyright © 2016 AYA.io. All rights reserved.
//

import Foundation

public class WeatherDescriptor {
    
    private let dateFormatter: NSDateFormatter
    
    public init() {
        dateFormatter = NSDateFormatter()
        dateFormatter.calendar = NSCalendar.currentCalendar()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "yyy/MM/dd HH:mm:ss"
    }
    
    public func describe(weather: CurrentWeather, style: WeatherDescriptionStyle = .DetailedString) {
        let d = makeDescription(weather, style: style)
        print(d)
    }
    
    private func makeDescription(weather: CurrentWeather, style: WeatherDescriptionStyle) -> String {
        let loc = "\(weather.city) (\(weather.country))"
        let ds = dateString(weather)
        let base = "\(loc), \(ds)."
        let temp = "Temp: \(weather.celsius) ºC."
        let normal = "\(base) \(temp)"
        let mood = "Ciel: \(weather.subCategory)."
        switch style {
        case .DetailedString:
            if let dir = weather.windDirection {
                return "\(normal) \(mood) Vent: \(dir.degreesToCompass()) à \(weather.windSpeed) km/h."
            } else {
                return "\(normal) \(mood)"
            }
        case .String:
            return normal
        case .MiniString:
            return temp
        }
    }
    
    private func dateString(weather: CurrentWeather) -> String {
        return dateFormatter.stringFromDate(weather.date)
    }
}
