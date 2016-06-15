//
//  CLI.swift
//  WeatherManCLI
//
//  Created by ERIC DEJONCKHEERE on 11/06/2016.
//  Copyright © 2016 AYA.io. All rights reserved.
//

import Foundation

public class CLI {
    
    let input: [String]
    var arguments = CLIArguments()
    let errorMessage = "Something went wrong. Please read the Help:\nweatherman -h"
    let helpMessage = "This is a simple WeatherMan application.\nNeeds `-t` for the town, and optionnally `-c` for a country and `-s` for a style (short, normal, long).\nExample:\nweatherman -t paris -c france -s short"
    
    init(input: [String]) {
        self.input = input
        makeArgs()
    }
    
    public func getArgs() -> CLIArguments? {
        if arguments.town.isEmpty {
            return nil
        }
        return arguments
    }
    
    private func makeArgs() {
        populate(Array(input.dropFirst()))
    }
    
    private func populate(args: [String]) {
        for (index, item) in args.enumerate() {
            if args.count > index + 1 {
                let it = item.lowercaseString
                if it == "-t" || it == "--town" {
                    arguments.town = args[index + 1].lowercaseString
                } else if it == "-c" || it == "--country" {
                    arguments.country = args[index + 1].lowercaseString
                } else if it == "-s" || it == "--help" {
                    let value = args[index + 1].lowercaseString
                    if value == "short" {
                        arguments.style = .MiniString
                    } else if value == "normal" {
                        arguments.style = .String
                    }
                }
            }
        }
        if arguments.style == nil {
            arguments.style = .DetailedString
        }
    }
    
}