//
//  CurrentWeather.swift
//  WeatherManCLI
//
//  Created by ERIC DEJONCKHEERE on 07/06/2016.
//  Copyright © 2016 AYA.io. All rights reserved.
//

import Foundation

public struct CurrentWeather {
    typealias MeterSecond = Double
    typealias KMHour = Double
    typealias MeteorologicalDegree = Int
    
    let date: NSDate
    let city: String
    let country: String
    let celsius: Int
    let category: String
    let subCategory: String
    let windSpeed: MeterSecond
    let windDirection: MeteorologicalDegree?
    let iconURL: NSURL
    
    var windSpeedKMH: KMHour {
        let s = windSpeed * 3.6
        return s.roundedOneDecimal()
    }
}