//
//  main.swift
//  WeatherManCLI
//
//  Created by ERIC DEJONCKHEERE on 07/06/2016.
//  Copyright © 2016 AYA.io. All rights reserved.
//

import Foundation

let cli = CLI(input: NSProcessInfo.processInfo().arguments)

if let args = cli.getArgs() {
    let wm = WeatherMan()
    if let country = args.country {
        wm.printCurrentWeather(args.town, country: country, style: args.style)
    } else {
        wm.printCurrentWeather(args.town, style: args.style)
    }
} else {
    print(cli.errorMessage)
    print(cli.helpMessage)
    exit(1)
}

dispatch_main()
