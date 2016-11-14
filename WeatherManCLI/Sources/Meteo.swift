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
                               completion: @escaping (WeatherResult)->()) {
        guard let url = makeURL(city, country: code) else {
            completion(WeatherResult(success: false, weather: nil, error: nil))
            return
        }
        getResponse(url) { (networkResult) in
            if let current = self.makeCurrentWeather(networkResult.json),
                networkResult.success 
            {
                let wr = WeatherResult(success: true, weather: current, error: nil)
                self.history.append(wr)
                completion(wr)
            } else {
                let wr = WeatherResult(success: false, weather: nil, error: networkResult.error)
                completion(wr)
            }
        }
    }
    
    private func getResponse(_ url: URL, completion: @escaping (NetworkResult)->()) {
        #if os(Linux)
            if let data = try? Data(contentsOf: url), let j = try? JSONSerialization.jsonObject(with: data), let json = j as? [String: Any] {
                completion(NetworkResult(success: true, json: json, error: nil))
            } else {
                completion(NetworkResult(success: false, json: nil, error: nil))
            }
        #else
            URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                if let data = data, error == nil, let j = try? JSONSerialization.jsonObject(with: data), let json = j as? [String: Any] {
                    completion(NetworkResult(success: true, json: json, error: nil))
                } else {
                    completion(NetworkResult(success: false, json: nil, error: error))
                }
            }.resume()
        #endif
        
    }
    
    private func makeCurrentWeather(_ json: [String: Any]) -> CurrentWeather? {
        guard let m = json["main"] as? [String: Any],
            let temp = m["temp"] as? Double,
            let wi = json["wind"] as? [String: Any],
            let speed = wi["speed"] as? Double,
            let we = json["weather"] as? [[String: Any]],
            let weather = we.first,
            let cat = weather["main"] as? String,
            let icon = weather["icon"] as? String,
            let iconURL = URL(string: "http://openweathermap.org/img/w/\(icon).png"),
            let desc = weather["description"] as? String,
            let city = json["name"] as? String,
            let s = json["sys"] as? [String: Any],
            let country = s["country"] as? String
            else { return nil 
        }
        return CurrentWeather(date: Date(),
                              city: city,
                              country: country,
                              celsius: temp,
                              category: cat,
                              subCategory: desc,
                              windSpeed: speed,
                              windDirection: wi["deg"] as? Int,
                              iconURL: iconURL)
    }
    
    private func makeURL(_ city: String, country code: String? = nil) -> URL? {
        guard let city = city.percentEncoded() else {
            return nil
        }
        if let c = code, let country = c.percentEncoded() {
            return URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city),\(country)&appid=\(appID)&units=metric&lang=fr")
        }
        return URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(appID)&units=metric&lang=fr")
    }
    
}
