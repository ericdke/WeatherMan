//
//  main.swift
//  WeatherManCLI
//
//  Created by ERIC DEJONCKHEERE on 07/06/2016.
//  Copyright © 2016 AYA.io. All rights reserved.
//

import Foundation

let cli = CLI(input: ProcessInfo.processInfo().arguments)

guard let args = cli.getArgs() else {
    print(cli.errorMessage)
    print(cli.helpMessage)
    exit(1)
}

let wm = WeatherMan()

if let country = args.country {
    wm.printCurrentWeather(city: args.town,
                           country: country,
                           style: args.style)
} else {
    wm.printCurrentWeather(city: args.town,
                           style: args.style)
}

dispatchMain()
