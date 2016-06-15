//
//  Meteo.swift
//  WeatherManCLI
//
//  Created by ERIC DEJONCKHEERE on 07/06/2016.
//  Copyright © 2016 AYA.io. All rights reserved.
//

import Foundation

public class Meteo {
    
    private let appID: String
    public var history: [WeatherResult] = []
    
    public init(appID: String) {
        self.appID = appID
    }
    
    public func currentWeather(city: String,
                               country code: String? = nil,
                                       completion: (weatherResult: WeatherResult)->()) {
        guard let url = makeURL(city, country: code) else {
            completion(weatherResult:
                WeatherResult(success: false, weather: nil, error: nil)
            ); return
        }
        getResponse(url) { (networkResult) in
            if let current = self.makeCurrentWeather(networkResult.json)
                where networkResult.success {
                let wr = WeatherResult(success: true, weather: current, error: nil)
                self.history.append(wr)
                completion(weatherResult: wr)
            } else {
                let wr = WeatherResult(success: false, weather: nil, error: networkResult.error)
                completion(weatherResult: wr)
            }
        }
    }
    
    private func getResponse(url: NSURL, completion: (networkResult: NetworkResult)->()) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (
            data: NSData?, response: NSURLResponse?, error: NSError?
            ) -> Void in
            if let data = data where error == nil {
                completion(networkResult:
                    NetworkResult(success: true, json: JSON(data: data), error: nil))
            } else {
                completion(networkResult:
                    NetworkResult(success: false, json: nil, error: error))
            }
            }.resume()
    }
    
    private func makeCurrentWeather(json: JSON) -> CurrentWeather? {
        guard let temp = json["main"]["temp"].int,
            speed = json["wind"]["speed"].double,
            cat = json["weather"][0]["main"].string,
            icon = json["weather"][0]["icon"].string,
            iconURL = NSURL(string: "http://openweathermap.org/img/w/\(icon).png"),
            desc = json["weather"][0]["description"].string,
            city = json["name"].string,
            country = json["sys"]["country"].string else {
                return nil
        }
        return CurrentWeather(date: NSDate(),
                              city: city,
                              country: country,
                              celsius: temp,
                              category: cat,
                              subCategory: desc,
                              windSpeed: speed,
                              windDirection: json["wind"]["deg"].int,
                              iconURL: iconURL)
    }
    
    private func makeURL(city: String, country code: String? = nil) -> NSURL? {
        guard let city = city.percentEncoded() else {
            return nil
        }
        if let c = code, country = c.percentEncoded() {
            return NSURL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city),\(country)&appid=\(appID)&units=metric&lang=fr")
        }
        return NSURL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(appID)&units=metric&lang=fr")
    }
    
}