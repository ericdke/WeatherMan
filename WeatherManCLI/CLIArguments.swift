//
//  CLICommands.swift
//  WeatherManCLI
//
//  Created by ERIC DEJONCKHEERE on 11/06/2016.
//  Copyright © 2016 AYA.io. All rights reserved.
//

import Foundation

public struct CLIArguments {
    var town: String = ""
    var country: String?
    var style: WeatherDescriptionStyle!
}